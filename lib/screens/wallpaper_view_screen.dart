import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import '../services/gallery_saver_service.dart';
import '../models/wallpaper_model.dart';
import '../services/admob_service.dart';
import '../services/image_resize_service.dart';
import '../utils/device_utils.dart';
import '../l10n/app_localizations.dart';

/// Full-screen wallpaper preview with download, set, and share actions
class WallpaperViewScreen extends StatefulWidget {
  final Wallpaper wallpaper;

  const WallpaperViewScreen({super.key, required this.wallpaper});

  @override
  State<WallpaperViewScreen> createState() => _WallpaperViewScreenState();
}

class _WallpaperViewScreenState extends State<WallpaperViewScreen>
    with SingleTickerProviderStateMixin {
  final AdMobService _adMobService = AdMobService();
  bool _showUI = true;
  bool _isDownloading = false;
  late AnimationController _uiAnimController;
  late Animation<double> _uiAnimation;

  @override
  void initState() {
    super.initState();
    _adMobService.loadRewardedAd(); // Precarga el anuncio recompensado
    _uiAnimController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
      value: 1.0,
    );
    _uiAnimation = CurvedAnimation(
      parent: _uiAnimController,
      curve: Curves.easeInOut,
    );

    // Enter immersive mode
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    _uiAnimController.dispose();
    // Restore system UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _toggleUI() {
    setState(() => _showUI = !_showUI);
    if (_showUI) {
      _uiAnimController.forward();
    } else {
      _uiAnimController.reverse();
    }
  }

  void _startDownloadWithAd() {
    if (_adMobService.isRewardedAdReady) {
      _adMobService.showRewardedAd(
        onRewarded: () {
          _downloadWallpaper();
        },
        onFailed: () {
          _downloadWallpaper(); // Si falla el anuncio, igual permitimos la descarga
        },
      );
    } else {
      _downloadWallpaper(); // Si no ha cargado, permitimos la descarga
    }
  }

  Future<Uint8List> _getImageBytes() async {
    if (widget.wallpaper.imageUrl.startsWith('assets/')) {
      final ByteData data = await rootBundle.load(widget.wallpaper.imageUrl);
      return data.buffer.asUint8List();
    } else {
      final response = await http.get(Uri.parse(widget.wallpaper.imageUrl));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        throw Exception('Failed to load image: ${response.statusCode}');
      }
    }
  }

  Future<void> _downloadWallpaper() async {
    setState(() => _isDownloading = true);

    try {
      final bytes = await _getImageBytes();
      if (!mounted) return; // Validación del BuildContext
      
      // Get the device provider
      final provider = Provider.of<DeviceProvider>(context, listen: false);
      final targetSize = provider.getWallpaperSize(context);
      final targetWidth = targetSize.width.toInt();
      final targetHeight = targetSize.height.toInt();

      // Resize the image to fit the selected device
      Uint8List finalBytes;
      if (targetWidth > 0 && targetHeight > 0) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Color(0xFF7C4DFF),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${AppLocalizations.t('resizing')} ${targetWidth}x$targetHeight...',
                  ),
                ],
              ),
              backgroundColor: const Color(0xFF1A1A2E),
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
        finalBytes = await ImageResizeService.resizeToDevice(
          imageBytes: bytes,
          targetWidth: targetWidth,
          targetHeight: targetHeight,
        );
      } else {
        finalBytes = bytes;
      }

      final deviceLabel = provider.isAutoDetect
          ? 'auto'
          : provider.selectedDeviceId;
      final fileName =
          'wallverse_${widget.wallpaper.id}_${deviceLabel}_${DateTime.now().millisecondsSinceEpoch}';
          
      // Save to public gallery (Pictures/WallVerse)
      final saved = await GallerySaverService.saveToGallery(
        imageBytes: finalBytes,
        fileName: fileName,
      );

      if (mounted && saved) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Color(0xFF2DD4BF)),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppLocalizations.t('download_success')),
                      Text(
                        '${targetWidth}x$targetHeight  •  ${provider.getSelectedDeviceLabel()}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF1A1A2E),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppLocalizations.t('error')}: $e'),
            backgroundColor: Colors.red.shade900,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isDownloading = false);
    }
  }

  Future<void> _setWallpaper() async {
    try {
      final bytes = await _getImageBytes();
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/temp_wallpaper.jpg');
      await file.writeAsBytes(bytes);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.wallpaper, color: Color(0xFF00B4D8)),
                const SizedBox(width: 8),
                Text(AppLocalizations.t('set_wallpaper_success')),
              ],
            ),
            backgroundColor: const Color(0xFF1A1A2E),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppLocalizations.t('error')}: $e'),
            backgroundColor: Colors.red.shade900,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _shareWallpaper() async {
    try {
      await Share.share(
        '${AppLocalizations.t('share_wallpaper')}\n${widget.wallpaper.imageUrl}',
      );
    } catch (e) {
      debugPrint('Share error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DeviceProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _toggleUI,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Wallpaper image with zoom
            InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: widget.wallpaper.imageUrl.startsWith('assets/')
                  ? Image.asset(
                      widget.wallpaper.imageUrl,
                      fit: BoxFit.cover,
                    )
                  : CachedNetworkImage(
                      imageUrl: widget.wallpaper.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: const Color(0xFF1A1A2E),
                        highlightColor: const Color(0xFF16213E),
                        child: Container(color: const Color(0xFF1A1A2E)),
                      ),
                      errorWidget: (context, url, error) => const Center(
                        child: Icon(
                          Icons.broken_image,
                          color: Colors.white38,
                          size: 64,
                        ),
                      ),
                    ),
            ),

            // Top gradient bar with back button + resolution + device info
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _uiAnimation,
                child: Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 8,
                    left: 16,
                    right: 16,
                    bottom: 12,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.15),
                            ),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                      const Spacer(),
                      // Device badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF7C4DFF).withOpacity(0.7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              provider.isAutoDetect
                                  ? Icons.auto_awesome
                                  : Icons.smartphone,
                              color: Colors.white,
                              size: 13,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              provider.isAutoDetect
                                  ? 'Auto'
                                  : provider.getSelectedDeviceLabel(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Resolution badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.15),
                            width: 1,
                          ),
                        ),
                        child: const Text(
                          '4K',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom action bar
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _uiAnimation,
                child: Container(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom + 20,
                    top: 24,
                    left: 24,
                    right: 24,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.8),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton(
                        icon: _isDownloading
                            ? Icons.hourglass_top
                            : Icons.download,
                        label: AppLocalizations.t('download'),
                        color: const Color(0xFF00B4D8),
                        onTap: _isDownloading ? null : _startDownloadWithAd,
                      ),
                      _buildActionButton(
                        icon: Icons.wallpaper,
                        label: AppLocalizations.t('set_wallpaper'),
                        color: const Color(0xFFE040FB),
                        onTap: _setWallpaper,
                      ),
                      _buildActionButton(
                        icon: Icons.share,
                        label: AppLocalizations.t('share'),
                        color: const Color(0xFF7C4DFF),
                        onTap: _shareWallpaper,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: color.withOpacity(0.4),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.2),
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getResolutionColor(String resolution) {
    switch (resolution) {
      case '8K':
        return const Color(0xFFFFD700);
      case '4K':
        return const Color(0xFF00B4D8);
      case 'HD':
      default:
        return const Color(0xFF2DD4BF);
    }
  }
}
