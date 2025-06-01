import 'package:news_app/core/datasource/remote_data/api_config.dart'; // Import the new ApiConfig
import 'package:news_app/core/datasource/remote_data/base_api_service.dart';

import '../models/news_article_model.dart';
import 'base_news_api_repository.dart';

class NewsApiRepositoryImpl implements BaseNewsApiRepository {
  final BaseApiService _apiService;

  NewsApiRepositoryImpl(this._apiService);

  @override
  Future<List<NewsArticle>> fetchTopHeadlines({String category = 'general'}) async {
    /// TODO : Task - Don't Send baseUrl .. add it on the BaseApiService then send endpoint only [سبها]
    final url =
        '${ApiConfig.baseUrl}${ApiConfig.topHeadlinesEndpoint}?country=us&category=$category&apiKey=${ApiConfig.apiKey}';
    final data = await _apiService.get(url);
    print(data['articles']);
    return (data['articles'] as List).map((e) => NewsArticle.fromJson(e)).toList();
  }

  @override
  Future<List<NewsArticle>> fetchEverything({required String query}) async {
    final url =
        '${ApiConfig.baseUrl}${ApiConfig.everythingEndpoint}?q=$query&sortBy=publishedAt&language=en&apiKey=${ApiConfig.apiKey}';
    final data = await _apiService.get(url);
    return (data['articles'] as List).map((e) => NewsArticle.fromJson(e)).toList();
  }
}
