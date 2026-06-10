import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'services/admob_service.dart';
import 'utils/device_utils.dart';
import 'screens/splash_screen.dart';

import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyDLSStBpWvWBUY9KkbpiSQ8l2-DiFPOr4k',
      appId: '1:425502023776:android:b63e578a1de24e4079e305',
      messagingSenderId: '425502023776',
      projectId: 'wallverse-4804c',
      storageBucket: 'wallverse-4804c.firebasestorage.app',
    ),
  );

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFF0A0A1A),
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  // Initialize AdMob
  final adMobService = AdMobService();
  await adMobService.initialize();

  runApp(const WallVerseApp());
}

class WallVerseApp extends StatelessWidget {
  const WallVerseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DeviceProvider(),
      child: Consumer<DeviceProvider>(
        builder: (context, provider, _) {
          return MaterialApp(
            title: 'WallVerse',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              brightness: Brightness.dark,
              scaffoldBackgroundColor: const Color(0xFF0A0A1A),
              primaryColor: const Color(0xFF00B4D8),
              colorScheme: const ColorScheme.dark(
                primary: Color(0xFF00B4D8),
                secondary: Color(0xFFE040FB),
                surface: Color(0xFF1A1A2E),
                error: Color(0xFFFF5252),
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFF0A0A1A),
                elevation: 0,
                centerTitle: true,
                titleTextStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
              cardTheme: CardTheme(
                color: const Color(0xFF1A1A2E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
              ),
              snackBarTheme: SnackBarThemeData(
                backgroundColor: const Color(0xFF1A1A2E),
                contentTextStyle: const TextStyle(color: Colors.white),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                behavior: SnackBarBehavior.floating,
              ),
              textTheme: const TextTheme(
                headlineLarge: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
                headlineMedium: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
                bodyLarge: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                bodyMedium: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
