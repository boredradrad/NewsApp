// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:news_app/core/constants/storage_key.dart';
import 'package:news_app/core/service_locator.dart';
import 'package:news_app/core/theme/light.dart';
import 'package:news_app/features/home/models/news_article_model.dart';
import 'package:news_app/features/splash/splash_screen.dart';
import 'package:news_app/features/main/main_screen.dart';
import 'package:news_app/features/onboarding/onboarding_screen.dart';
import 'package:news_app/features/auth/sign_in_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/services/preferences_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferencesManager().init();
  await dotenv.load(fileName: ".env");
  await Hive.initFlutter();

  Hive.registerAdapter(NewsArticleAdapter());
  await Hive.openBox('bookmarks');
  await Hive.openBox('settings');

  setupLocator();

  runApp(const NewsApp());
}

class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      home: const SplashScreenWrapper(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/main': (_) => const MainScreen(),
        '/onboarding': (_) => const OnboardingScreen(),
        '/signin': (_) => const SignInScreen(),
      },
    );
  }
}

class SplashScreenWrapper extends StatefulWidget {
  const SplashScreenWrapper({super.key});

  @override
  State<SplashScreenWrapper> createState() => _SplashScreenWrapperState();
}

class _SplashScreenWrapperState extends State<SplashScreenWrapper> {
  @override
  void initState() {
    super.initState();
    _navigateAfterSplash();
  }

  Future<void> _navigateAfterSplash() async {
    await Future.delayed(const Duration(seconds: 2));

    final onboardingComplete = PreferencesManager().getBool(StorageKey.isBoardingComplete) ?? false;
    final isLoggedIn = PreferencesManager().getBool(StorageKey.isLoggedIn) ?? false;
    if (!mounted) return;
    if (!onboardingComplete) {
      Navigator.of(context).pushReplacementNamed('/onboarding');
    } else if (!isLoggedIn) {
      Navigator.of(context).pushReplacementNamed('/signin');
    } else {
      Navigator.of(context).pushReplacementNamed('/main');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}
