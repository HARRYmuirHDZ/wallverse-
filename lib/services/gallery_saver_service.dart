import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

/// Saves wallpapers to the device's public Pictures directory
/// so they appear in the Gallery app. No extra plugins needed.
class GallerySaverService {
  static const _channel = MethodChannel('com.wallverse.wallverse/gallery');

  /// Saves image bytes to the public Pictures/WallVerse folder
  /// and notifies the media scanner so it appears in the Gallery.
  static Future<bool> saveToGallery({
    required Uint8List imageBytes,
    required String fileName,
  }) async {
    try {
      // Request storage permission on older Android versions
      if (Platform.isAndroid) {
        final status = await Permission.storage.request();
        if (!status.isGranted) {
          // Try photos permission for Android 13+
          await Permission.photos.request();
        }
      }

      // Get external storage directory
      final directory = await getExternalStorageDirectory();
      if (directory == null) return false;

      // Navigate to Pictures/WallVerse in public storage
      // External storage path is like /storage/emulated/0/Android/data/...
      // We go up to /storage/emulated/0/ and then to Pictures/WallVerse
      final parts = directory.path.split('/Android/');
      final publicPath = '${parts[0]}/Pictures/WallVerse';

      final wallverseDir = Directory(publicPath);
      if (!await wallverseDir.exists()) {
        await wallverseDir.create(recursive: true);
      }

      // Save the file
      final file = File('$publicPath/$fileName.png');
      await file.writeAsBytes(imageBytes);

      // Notify the media scanner so the image appears in Gallery
      try {
        await _channel.invokeMethod('scanFile', {'path': file.path});
      } catch (_) {
        // If the method channel isn't set up, the file is still saved
        // It will appear in gallery after a reboot or manual scan
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}
