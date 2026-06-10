import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../models/subcategory_model.dart';
import '../models/wallpaper_model.dart';
import '../services/firebase_service.dart';
import '../services/admob_service.dart';
import '../utils/device_utils.dart';
import '../widgets/wallpaper_card.dart';
import '../widgets/loading_widget.dart';
import '../l10n/app_localizations.dart';
import 'wallpaper_view_screen.dart';

/// Pinterest-style wallpaper grid with pagination and ad integration
class WallpaperGridScreen extends StatefulWidget {
  final Subcategory subcategory;
  final String categoryName;

  const WallpaperGridScreen({
    super.key,
    required this.subcategory,
    required this.categoryName,
  });

  @override
  State<WallpaperGridScreen> createState() => _WallpaperGridScreenState();
}

class _WallpaperGridScreenState extends State<WallpaperGridScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  final AdMobService _adMobService = AdMobService();
  final ScrollController _scrollController = ScrollController();
  final List<Wallpaper> _wallpapers = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  BannerAd? _bannerAd;
  bool _isBannerLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadWallpapers();
    _loadBannerAd();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _bannerAd?.dispose();
    super.dispose();
  }

  Future<void> _loadWallpapers() async {
    try {
      final wallpapers = await _firebaseService.getWallpapers(
        widget.subcategory.id,
        limit: 20,
      );
      if (mounted) {
        setState(() {
          _wallpapers.addAll(wallpapers);
          _isLoading = false;
          _hasMore = wallpapers.length >= 20;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loadMoreWallpapers() async {
    if (_isLoadingMore || !_hasMore) return;
    setState(() => _isLoadingMore = true);

    try {
      final wallpapers = await _firebaseService.getWallpapers(
        widget.subcategory.id,
        limit: 20,
        startAfterId: _wallpapers.isNotEmpty ? _wallpapers.last.id : null,
      );
      if (mounted) {
        setState(() {
          _wallpapers.addAll(wallpapers);
          _isLoadingMore = false;
          _hasMore = wallpapers.length >= 20;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingMore = false);
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreWallpapers();
    }
  }

  void _loadBannerAd() {
    _bannerAd = _adMobService.createBannerAd(
      onLoaded: () {
        if (mounted) setState(() => _isBannerLoaded = true);
      },
    );
    _bannerAd?.load();
  }

  void _onWallpaperTap(Wallpaper wallpaper) {
    if (!wallpaper.isAccessible) {
      // Show rewarded ad dialog
      _showUnlockDialog(wallpaper);
    } else {
      _openWallpaperView(wallpaper);
    }
  }

  void _showUnlockDialog(Wallpaper wallpaper) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(
            color: Color(0xFFE040FB),
            width: 1,
          ),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFE040FB).withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock,
                color: Color(0xFFE040FB),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                AppLocalizations.t('premium_wallpaper'),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          AppLocalizations.t('watch_ad_to_unlock'),
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppLocalizations.t('cancel'),
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _watchRewardedAd(wallpaper);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE040FB),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.play_circle_outline, size: 18),
                const SizedBox(width: 6),
                Text(AppLocalizations.t('watch_ad')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _watchRewardedAd(Wallpaper wallpaper) {
    if (!_adMobService.isRewardedAdReady) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.t('ad_not_ready')),
          backgroundColor: const Color(0xFF1A1A2E),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    _adMobService.showRewardedAd(
      onRewarded: () {
        setState(() {
          wallpaper.isUnlocked = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.lock_open, color: Color(0xFF2DD4BF)),
                const SizedBox(width: 8),
                Text(AppLocalizations.t('wallpaper_unlocked')),
              ],
            ),
            backgroundColor: const Color(0xFF1A1A2E),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
        // Open the wallpaper view after unlocking
        _openWallpaperView(wallpaper);
      },
      onFailed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.t('ad_not_ready')),
            backgroundColor: const Color(0xFF1A1A2E),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
    );
  }

  void _openWallpaperView(Wallpaper wallpaper) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WallpaperViewScreen(wallpaper: wallpaper),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DeviceProvider>(context);
    final columns = provider.getGridColumns();
    final displayName = AppLocalizations.t(widget.subcategory.name);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A1A),
      body: SafeArea(
        child: Column(
          children: [
            // App bar
            _buildAppBar(displayName),

            // Grid
            Expanded(
              child: _isLoading
                  ? LoadingWidget(message: AppLocalizations.t('loading'))
                  : _wallpapers.isEmpty
                      ? _buildEmptyState()
                      : _buildWallpaperGrid(columns),
            ),

            // Loading more indicator
            if (_isLoadingMore)
              const Padding(
                padding: EdgeInsets.all(16),
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF00B4D8),
                    ),
                  ),
                ),
              ),

            // Banner Ad
            if (_isBannerLoaded && _bannerAd != null)
              Container(
                width: double.infinity,
                height: _bannerAd!.size.height.toDouble(),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F0F23),
                  border: Border(
                    top: BorderSide(
                      color: Colors.white.withOpacity(0.05),
                    ),
                  ),
                ),
                child: AdWidget(ad: _bannerAd!),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  AppLocalizations.t(widget.categoryName),
                  style: TextStyle(
                    color: const Color(0xFF00B4D8).withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFF00B4D8).withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${_wallpapers.length}',
              style: const TextStyle(
                color: Color(0xFF00B4D8),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported_outlined,
            size: 64,
            color: Colors.white.withOpacity(0.2),
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.t('no_wallpapers'),
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWallpaperGrid(int columns) {
    return MasonryGridView.count(
      controller: _scrollController,
      crossAxisCount: columns,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      itemCount: _wallpapers.length,
      itemBuilder: (context, index) {
        final wallpaper = _wallpapers[index];
        // Vary heights for Pinterest-style layout
        final heights = [220.0, 280.0, 250.0, 300.0, 240.0, 260.0];
        final height = heights[index % heights.length];

        return WallpaperCard(
          wallpaper: wallpaper,
          height: height,
          onTap: () => _onWallpaperTap(wallpaper),
        );
      },
    );
  }
}
