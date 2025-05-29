import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news_app/models/news_article_model.dart';

class NewsService {
  static const String apiKey = 'YOUR_NEWSAPI_KEY';
  static const String baseUrl = 'https://newsapi.org/v2';

  Future<List<NewsArticle>> fetchTopHeadlines({String category = 'general'}) async {
    final url = Uri.parse(
      '$baseUrl/top-headlines?country=us&category=$category&apiKey=$apiKey',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final articles = data['articles'] as List;

      return articles.map((e) => NewsArticle.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load news');
    }
  }
}
