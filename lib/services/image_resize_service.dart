import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// Service to resize and crop wallpaper images to fit a specific device resolution.
/// Uses center-crop strategy to fill the entire screen without distortion.
class ImageResizeService {
  /// Resizes and crops the image bytes to the target [width] and [height].
  /// Uses a center-crop approach (similar to BoxFit.cover) so the image
  /// fills the entire target dimensions without stretching.
  static Future<Uint8List> resizeToDevice({
    required Uint8List imageBytes,
    required int targetWidth,
    required int targetHeight,
  }) async {
    // Decode the original image
    final codec = await ui.instantiateImageCodec(imageBytes);
    final frame = await codec.getNextFrame();
    final originalImage = frame.image;

    final int srcWidth = originalImage.width;
    final int srcHeight = originalImage.height;
    final double targetAspect = targetWidth / targetHeight;
    final double srcAspect = srcWidth / srcHeight;

    // Calculate the source rectangle (center-crop)
    int cropX, cropY, cropWidth, cropHeight;
    if (srcAspect > targetAspect) {
      // Source is wider → crop sides
      cropHeight = srcHeight;
      cropWidth = (srcHeight * targetAspect).round();
      cropX = ((srcWidth - cropWidth) / 2).round();
      cropY = 0;
    } else {
      // Source is taller → crop top/bottom
      cropWidth = srcWidth;
      cropHeight = (srcWidth / targetAspect).round();
      cropX = 0;
      cropY = ((srcHeight - cropHeight) / 2).round();
    }

    // Create the recorder and canvas
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // Draw the cropped and scaled image
    canvas.drawImageRect(
      originalImage,
      Rect.fromLTWH(
        cropX.toDouble(),
        cropY.toDouble(),
        cropWidth.toDouble(),
        cropHeight.toDouble(),
      ),
      Rect.fromLTWH(
        0,
        0,
        targetWidth.toDouble(),
        targetHeight.toDouble(),
      ),
      Paint()..filterQuality = FilterQuality.high,
    );

    // Convert to image
    final picture = recorder.endRecording();
    final resizedImage = await picture.toImage(targetWidth, targetHeight);

    // Encode to PNG bytes
    final byteData =
        await resizedImage.toByteData(format: ui.ImageByteFormat.png);
    
    originalImage.dispose();
    resizedImage.dispose();

    if (byteData != null) {
      return byteData.buffer.asUint8List();
    }

    // Fallback: return original if encoding fails
    return imageBytes;
  }
}
