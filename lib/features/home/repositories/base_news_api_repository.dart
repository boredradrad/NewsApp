import '../models/news_article_model.dart';

abstract class BaseNewsApiRepository {
  Future<List<NewsArticle>> fetchTopHeadlines({String category = 'general'});
  Future<List<NewsArticle>> fetchEverything({required String query});
}