import 'package:flutter/material.dart';
import '../widgets/animated_builder.dart';
import '../l10n/app_localizations.dart';
import 'home_screen.dart';

/// Modern splash screen with dark futuristic theme
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _gridController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _gridFadeAnimation;
  late Animation<double> _subtitleFadeAnimation;

  // Wallpaper collage URLs
  final List<String> _collageImages = [
    'https://picsum.photos/seed/anime1/400/600',
    'https://picsum.photos/seed/cyber1/400/600',
    'https://picsum.photos/seed/space1/400/600',
    'https://picsum.photos/seed/cars1/400/600',
    'https://picsum.photos/seed/neon1/400/600',
    'https://picsum.photos/seed/nature1/400/600',
    'https://picsum.photos/seed/game1/400/600',
    'https://picsum.photos/seed/movie1/400/600',
    'https://picsum.photos/seed/minimal1/400/600',
    'https://picsum.photos/seed/abstract1/400/600',
    'https://picsum.photos/seed/cyber2/400/600',
    'https://picsum.photos/seed/space2/400/600',
  ];

  @override
  void initState() {
    super.initState();

    _gridController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _gridFadeAnimation = Tween<double>(begin: 0.0, end: 0.4).animate(
      CurvedAnimation(parent: _gridController, curve: Curves.easeIn),
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _subtitleFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );

    // Start animations sequence
    _gridController.forward();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _fadeController.forward();
        _scaleController.forward();
      }
    });

    // Navigate to home
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const HomeScreen(),
            transitionDuration: const Duration(milliseconds: 800),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _gridController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A1A),
      body: Stack(
        children: [
          // Background collage grid
          WallVerseAnimatedBuilder(
            animation: _gridFadeAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: _gridFadeAnimation.value,
                child: child,
              );
            },
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.65,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: _collageImages.length,
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    _collageImages[index],
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.primaries[index % Colors.primaries.length]
                                .withOpacity(0.3),
                            Colors.primaries[(index + 3) % Colors.primaries.length]
                                .withOpacity(0.1),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Dark gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.2,
                colors: [
                  const Color(0xFF0A0A1A).withOpacity(0.6),
                  const Color(0xFF0A0A1A).withOpacity(0.85),
                  const Color(0xFF0A0A1A).withOpacity(0.95),
                ],
              ),
            ),
          ),

          // Animated neon circles
          Positioned(
            top: size.height * 0.2,
            left: size.width * 0.1,
            child: _buildGlowOrb(60, const Color(0xFF00B4D8)),
          ),
          Positioned(
            bottom: size.height * 0.25,
            right: size.width * 0.15,
            child: _buildGlowOrb(40, const Color(0xFFE040FB)),
          ),
          Positioned(
            top: size.height * 0.6,
            left: size.width * 0.7,
            child: _buildGlowOrb(30, const Color(0xFF7C4DFF)),
          ),

          // Center content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App icon
                WallVerseAnimatedBuilder(
                  animation: _scaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: child,
                      ),
                    );
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF00B4D8),
                          Color(0xFF7C4DFF),
                          Color(0xFFE040FB),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00B4D8).withOpacity(0.4),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.wallpaper,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // App name
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [
                        Color(0xFF00B4D8),
                        Color(0xFFE040FB),
                      ],
                    ).createShader(bounds),
                    child: const Text(
                      'WallVerse',
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 3,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Tagline
                FadeTransition(
                  opacity: _subtitleFadeAnimation,
                  child: Text(
                    AppLocalizations.t('app_tagline'),
                    style: const TextStyle(
                      color: Color(0xFF90CAF9),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 4,
                    ),
                  ),
                ),

                const SizedBox(height: 60),

                // Loading indicator
                FadeTransition(
                  opacity: _subtitleFadeAnimation,
                  child: SizedBox(
                    width: 120,
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.white.withOpacity(0.1),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF00B4D8),
                      ),
                      minHeight: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlowOrb(double size, Color color) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.3, end: 0.7),
      duration: const Duration(seconds: 2),
      builder: (context, value, child) {
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(value * 0.15),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(value * 0.3),
                blurRadius: size,
                spreadRadius: size * 0.3,
              ),
            ],
          ),
        );
      },
    );
  }
}

