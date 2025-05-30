// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:news_app/core/service_locator.dart';
import 'package:news_app/core/theme/light.dart';
import 'package:news_app/features/home/models/news_article_model.dart';
import 'package:news_app/features/main/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
