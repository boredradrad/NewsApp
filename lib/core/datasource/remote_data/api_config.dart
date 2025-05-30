import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static const String baseUrl = 'https://newsapi.org/v2';
  static String get apiKey => dotenv.env['API_KEY'] ?? 'default_key';
  static const String topHeadlinesEndpoint = '/top-headlines';
  static const String everythingEndpoint = '/everything';
}