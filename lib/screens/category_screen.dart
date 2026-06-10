import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../models/category_model.dart';
import '../models/subcategory_model.dart';
import '../services/firebase_service.dart';
import '../services/admob_service.dart';
import '../widgets/loading_widget.dart';
import '../l10n/app_localizations.dart';
import 'wallpaper_grid_screen.dart';

/// Subcategory list screen for a selected category
class CategoryScreen extends StatefulWidget {
  final Category category;

  const CategoryScreen({super.key, required this.category});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    with SingleTickerProviderStateMixin {
  final FirebaseService _firebaseService = FirebaseService();
  final AdMobService _adMobService = AdMobService();
  List<Subcategory> _subcategories = [];
  bool _isLoading = true;
  BannerAd? _bannerAd;
  bool _isBannerLoaded = false;
  late AnimationController _listController;

  @override
  void initState() {
    super.initState();
    _listController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _loadSubcategories();
    _loadBannerAd();
  }

  @override
  void dispose() {
    _listController.dispose();
    _bannerAd?.dispose();
    super.dispose();
  }

  Future<void> _loadSubcategories() async {
    try {
      final subs = await _firebaseService.getSubcategories(widget.category.id);
      if (mounted) {
        setState(() {
          _subcategories = subs;
          _isLoading = false;
        });
        _listController.forward();
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
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

  // Get unique gradient for subcategory items
  List<Color> _getSubcategoryGradient(int index) {
    final gradients = [
      [const Color(0xFF00B4D8), const Color(0xFF0077B6)],
      [const Color(0xFFE040FB), const Color(0xFF7C4DFF)],
      [const Color(0xFFFF6B9D), const Color(0xFFC44569)],
      [const Color(0xFF2DD4BF), const Color(0xFF059669)],
      [const Color(0xFFFFBE0B), const Color(0xFFFB5607)],
    ];
    return gradients[index % gradients.length];
  }

  IconData _getSubcategoryIcon(String name) {
    // Map some well-known subcategories to icons
    final iconMap = {
      'naruto': Icons.bolt,
      'dragon_ball': Icons.local_fire_department,
      'dragon_ball_2': Icons.local_fire_department,
      'demon_slayer': Icons.whatshot,
      'one_piece': Icons.sailing,
      'attack_on_titan': Icons.shield,
      'roblox': Icons.extension,
      'minecraft': Icons.grid_view,
      'call_of_duty': Icons.gps_fixed,
      'fortnite': Icons.storm,
      'gta': Icons.directions_car,
      'marvel': Icons.flash_on,
      'dc': Icons.nights_stay,
      'star_wars': Icons.star,
      'harry_potter': Icons.auto_fix_high,
      'avatar': Icons.nature,
      'mountains': Icons.terrain,
      'beaches': Icons.beach_access,
      'forest': Icons.forest,
      'waterfalls': Icons.water,
      'sunsets': Icons.wb_twilight,
      'neon_city': Icons.location_city,
      'neon_signs': Icons.signpost,
      'neon_abstract': Icons.blur_circular,
      'neon_portraits': Icons.face,
      'neon_gaming': Icons.sports_esports,
      'sports_cars': Icons.speed,
      'classic_cars': Icons.time_to_leave,
      'super_cars': Icons.rocket,
      'jdm': Icons.tune,
      'modified': Icons.build,
      'galaxies': Icons.blur_on,
      'planets': Icons.public,
      'nebula': Icons.cloud,
      'astronaut': Icons.person,
      'black_hole': Icons.lens,
      'geometric': Icons.hexagon,
      'gradients': Icons.gradient,
      'typography': Icons.text_fields,
      'line_art': Icons.draw,
      'abstract': Icons.auto_awesome_mosaic,
    };
    return iconMap[name] ?? Icons.image;
  }

  @override
  Widget build(BuildContext context) {
    final categoryDisplayName = AppLocalizations.t(widget.category.name);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A1A),
      body: SafeArea(
        child: Column(
          children: [
            // Custom app bar
            _buildAppBar(categoryDisplayName),

            // Subcategory list
            Expanded(
              child: _isLoading
                  ? LoadingWidget(message: AppLocalizations.t('loading'))
                  : _buildSubcategoryList(),
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
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFF00B4D8).withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${_subcategories.length}',
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

  Widget _buildSubcategoryList() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _subcategories.length,
      itemBuilder: (context, index) {
        final sub = _subcategories[index];
        final gradient = _getSubcategoryGradient(index);
        final icon = _getSubcategoryIcon(sub.name);
        final displayName = AppLocalizations.t(sub.name);

        // Stagger animation
        final delay = index * 0.15;
        final animation = Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: _listController,
            curve: Interval(
              delay.clamp(0.0, 0.7),
              (delay + 0.3).clamp(0.0, 1.0),
              curve: Curves.easeOutCubic,
            ),
          ),
        );

        return _AnimatedListItem(
          animation: animation,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => WallpaperGridScreen(
                    subcategory: sub,
                    categoryName: widget.category.name,
                  ),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    gradient[0].withOpacity(0.15),
                    gradient[1].withOpacity(0.05),
                  ],
                ),
                border: Border.all(
                  color: gradient[0].withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: gradient[0].withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: gradient[0], size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '4K',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.4),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: gradient[0].withOpacity(0.6),
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Animated list item with slide + fade
class _AnimatedListItem extends AnimatedWidget {
  final Widget child;

  const _AnimatedListItem({
    required Animation<double> animation,
    required this.child,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Transform.translate(
      offset: Offset(40 * (1 - animation.value), 0),
      child: Opacity(
        opacity: animation.value,
        child: child,
      ),
    );
  }
}
