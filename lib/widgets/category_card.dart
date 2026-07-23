import 'package:flutter/material.dart';
import 'animated_builder.dart';
import '../l10n/app_localizations.dart';

/// Glassmorphism-style category card with neon glow effect
class CategoryCard extends StatefulWidget {
  final String categoryName;
  final String iconName;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.categoryName,
    required this.iconName,
    required this.onTap,
  });

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  IconData _getCategoryIcon(String iconName) {
    switch (iconName) {
      case 'anime':
        return Icons.auto_awesome;
      case 'games':
        return Icons.sports_esports;
      case 'movies':
        return Icons.movie;
      case 'nature':
        return Icons.eco;
      case 'neon':
        return Icons.flash_on;
      case 'cars':
        return Icons.directions_car;
      case 'space':
        return Icons.rocket_launch;
      case 'minimalist':
        return Icons.crop_square;
      default:
        return Icons.category;
    }
  }

  List<Color> _getCategoryGradient(String iconName) {
    switch (iconName) {
      case 'anime':
        return [const Color(0xFFFF6B9D), const Color(0xFFC44569)];
      case 'games':
        return [const Color(0xFF00B4D8), const Color(0xFF0077B6)];
      case 'movies':
        return [const Color(0xFFFFBE0B), const Color(0xFFFB5607)];
      case 'nature':
        return [const Color(0xFF2DD4BF), const Color(0xFF059669)];
      case 'neon':
        return [const Color(0xFFE040FB), const Color(0xFF7C4DFF)];
      case 'cars':
        return [const Color(0xFFFF5722), const Color(0xFFD84315)];
      case 'space':
        return [const Color(0xFF7C4DFF), const Color(0xFF304FFE)];
      case 'minimalist':
        return [const Color(0xFF90A4AE), const Color(0xFF546E7A)];
      default:
        return [const Color(0xFF00B4D8), const Color(0xFF0077B6)];
    }
  }

  @override
  Widget build(BuildContext context) {
    final icon = _getCategoryIcon(widget.iconName);
    final gradient = _getCategoryGradient(widget.iconName);
    final displayName = AppLocalizations.t(widget.categoryName);

    return GestureDetector(
      onTapDown: (_) {
        _controller.forward();
        setState(() => _isHovered = true);
      },
      onTapUp: (_) {
        _controller.reverse();
        setState(() => _isHovered = false);
        widget.onTap();
      },
      onTapCancel: () {
        _controller.reverse();
        setState(() => _isHovered = false);
      },
      child: WallVerseAnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                gradient[0].withOpacity(_isHovered ? 0.4 : 0.25),
                gradient[1].withOpacity(_isHovered ? 0.3 : 0.15),
              ],
            ),
            border: Border.all(
              color: gradient[0].withOpacity(_isHovered ? 0.6 : 0.3),
              width: 1.5,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: gradient[0].withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                // Background image for anime category
                if (widget.iconName == 'anime') ...[
                  Positioned.fill(
                    child: Image.asset(
                      'assets/images/anime_bg.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned.fill(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      color: Colors.black.withOpacity(_isHovered ? 0.4 : 0.55),
                    ),
                  ),
                ] else if (widget.iconName == 'cars') ...[
                  Positioned.fill(
                    child: Image.asset(
                      'assets/images/jdm_neon.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned.fill(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      color: Colors.black.withOpacity(_isHovered ? 0.4 : 0.55),
                    ),
                  ),
                ] else if (widget.iconName == 'neon') ...[
                  Positioned.fill(
                    child: Image.asset(
                      'assets/images/neon_bg.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned.fill(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      color: Colors.black.withOpacity(_isHovered ? 0.4 : 0.55),
                    ),
                  ),
                ],
                // Background decoration circles for other categories
                if (widget.iconName != 'anime' && widget.iconName != 'cars' && widget.iconName != 'neon') ...[
                  Positioned(
                    top: -20,
                    right: -20,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: gradient[0].withOpacity(0.15),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -10,
                    left: -10,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: gradient[1].withOpacity(0.1),
                      ),
                    ),
                  ),
                ],
                // Content
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.iconName != 'anime' && widget.iconName != 'cars' && widget.iconName != 'neon') ...[
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: gradient[0].withOpacity(0.2),
                            boxShadow: [
                              BoxShadow(
                                color: gradient[0].withOpacity(0.3),
                                blurRadius: 12,
                              ),
                            ],
                          ),
                          child: Icon(
                            icon,
                            size: 32,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      Text(
                        displayName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

