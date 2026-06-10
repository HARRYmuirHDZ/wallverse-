import 'package:flutter/material.dart';
import '../widgets/animated_builder.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../services/firebase_service.dart';
import '../services/admob_service.dart';
import '../utils/device_utils.dart';
import '../widgets/category_card.dart';
import '../widgets/loading_widget.dart';
import '../widgets/device_selector_sheet.dart';
import '../models/category_model.dart';
import 'category_screen.dart';
import 'wallpaper_grid_screen.dart';
import '../models/subcategory_model.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Home screen displaying category grid with device selector and language picker
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final FirebaseService _firebaseService = FirebaseService();
  final AdMobService _adMobService = AdMobService();
  List<Category> _categories = [];
  bool _isLoading = true;
  BannerAd? _bannerAd;
  bool _isBannerLoaded = false;
  late AnimationController _staggerController;

  @override
  void initState() {
    super.initState();
    _staggerController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _loadCategories();
    _loadBannerAd();
    _adMobService.loadInterstitialAd();
    _adMobService.loadRewardedAd();
  }

  @override
  void dispose() {
    _staggerController.dispose();
    _bannerAd?.dispose();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await _firebaseService.getCategories();
      if (mounted) {
        setState(() {
          _categories = categories;
          _isLoading = false;
        });
        _staggerController.forward();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
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

  void _showLanguageDialog() {
    final provider = Provider.of<DeviceProvider>(context, listen: false);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A2E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(
            top: BorderSide(color: Color(0xFF00B4D8), width: 1),
            left: BorderSide(color: Color(0xFF00B4D8), width: 0.5),
            right: BorderSide(color: Color(0xFF00B4D8), width: 0.5),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.t('select_language'),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            ...AppLocalizations.supportedLocales.map((locale) {
              final isSelected = provider.languageCode == locale.code;
              return ListTile(
                leading: Text(
                  locale.flag,
                  style: const TextStyle(fontSize: 28),
                ),
                title: Text(
                  locale.name,
                  style: TextStyle(
                    color: isSelected
                        ? const Color(0xFF00B4D8)
                        : Colors.white,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
                trailing: isSelected
                    ? const Icon(Icons.check_circle,
                        color: Color(0xFF00B4D8))
                    : null,
                onTap: () {
                  provider.setLanguage(locale.code);
                  Navigator.pop(context);
                  setState(() {}); // Rebuild with new language
                },
              );
            }),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showDeviceSelector() {
    DeviceSelectorSheet.show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A1A),
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar
            _buildAppBar(),

            // Category Grid
            Expanded(
              child: _isLoading
                  ? LoadingWidget(message: AppLocalizations.t('loading'))
                  : _buildCategoryGrid(),
            ),

            // Banner Ad
            if (_isBannerLoaded && _bannerAd != null)
              Container(
                width: double.infinity,
                height: _bannerAd!.size.height.toDouble(),
                margin: const EdgeInsets.only(top: 4),
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

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          // App logo & name
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFF00B4D8), Color(0xFFE040FB)],
            ).createShader(bounds),
            child: const Text(
              'WallVerse',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFF00B4D8).withOpacity(0.15),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: const Color(0xFF00B4D8).withOpacity(0.3),
              ),
            ),
            child: const Text(
              'BETA',
              style: TextStyle(
                color: Color(0xFF00B4D8),
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
          ),
          const Spacer(),
          // Language button
          _buildActionButton(
            icon: Icons.translate,
            onTap: _showLanguageDialog,
            color: const Color(0xFF00B4D8),
          ),
          const SizedBox(width: 8),
          // Device selector button
          _buildActionButton(
            icon: Icons.devices,
            onTap: _showDeviceSelector,
            color: const Color(0xFF7C4DFF),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.25),
          ),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }

  Widget _buildCategoryGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 16, top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.t('categories'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppLocalizations.t('app_tagline'),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          // Grid
          Expanded(
            child: GridView.builder(
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.1,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
              ),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                // Stagger animation
                final delay = index * 0.1;
                final animation = Tween<double>(begin: 0, end: 1).animate(
                  CurvedAnimation(
                    parent: _staggerController,
                    curve: Interval(
                      delay.clamp(0.0, 0.8),
                      (delay + 0.4).clamp(0.0, 1.0),
                      curve: Curves.easeOutCubic,
                    ),
                  ),
                );

                return WallVerseAnimatedBuilder(
                  animation: animation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, 30 * (1 - animation.value)),
                      child: Opacity(
                        opacity: animation.value,
                        child: child,
                      ),
                    );
                  },
                  child: CategoryCard(
                    categoryName: category.name,
                    iconName: category.iconName,
                    onTap: () {
                      if (category.id == 'cars') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => WallpaperGridScreen(
                              subcategory: Subcategory(
                                id: 'cars_all',
                                categoryId: 'cars',
                                name: 'cars',
                              ),
                              categoryName: category.name,
                            ),
                          ),
                        );
                      } else if (category.id == 'nature') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => WallpaperGridScreen(
                              subcategory: Subcategory(
                                id: 'nature_all',
                                categoryId: 'nature',
                                name: 'nature',
                              ),
                              categoryName: category.name,
                            ),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CategoryScreen(
                              category: category,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

