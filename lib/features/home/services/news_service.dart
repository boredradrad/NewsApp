import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news_app/features/home/models/news_article_model.dart';

class NewsService {
  static const String apiKey = '6b6a60f37b8144b195ec3aab5ae6f414';
  static const String baseUrl = 'https://newsapi.org/v2';

  Future<List<NewsArticle>> fetchTopHeadlines({String category = 'general'}) async {
    final url = Uri.parse(
      '$baseUrl/top-headlines?country=us&category=$category&apiKey=$apiKey',
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['articles'] as List).map((e) => NewsArticle.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load headlines');
    }
  }

  Future<List<NewsArticle>> fetchEverything({required String query}) async {
    final url = Uri.parse(
      '$baseUrl/everything?q=$query&sortBy=publishedAt&language=en&apiKey=$apiKey',
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['articles'] as List).map((e) => NewsArticle.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load everything');
    }
  }
}
