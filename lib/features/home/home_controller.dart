import 'package:flutter/cupertino.dart';
import 'package:news_app/core/extentions/extensions.dart';
import 'package:news_app/features/home/repositories/base_news_api_repository.dart';
import '../../core/service_locator.dart';
import 'models/news_article_model.dart';

class HomeController extends ChangeNotifier{

  final BaseNewsApiRepository _repository = locator<BaseNewsApiRepository>();
  List<NewsArticle> topHeadlines = [];
  List<NewsArticle> everythingArticles = [];
  bool isLoadingHeadlines = true;
  bool isLoadingEverything = true;
  String selectedCategory = 'Top News';


  init() {
    loadNews();
  }

  final List<String> categories = [
    'Top News',
    'business',
    'entertainment',
    'general',
    'health',
    'science',
    'sports',
    'technology',
  ];
  Future<void> loadNews() async {

      isLoadingHeadlines = true;
      isLoadingEverything = true;

    try {
      final headlines = await _repository.fetchTopHeadlines(
        category: selectedCategory == 'Top News' ? 'general' : selectedCategory,
      );
        topHeadlines = headlines;
        isLoadingHeadlines = false;

    } catch (_) {

        topHeadlines = [];
        isLoadingHeadlines = false;

    }
    finally{
      notifyListeners();
    }

    try {
      final everything = await _repository.fetchEverything(
        query: selectedCategory == 'Top News' ? 'news' : selectedCategory,
      );

        everythingArticles = everything;
        isLoadingEverything = false;

    } catch (_) {

        everythingArticles = [];
        isLoadingEverything = false;
    }
    finally{
      notifyListeners();
    }

  }

  /// TODO-Done : Task - Make this extension
  String formatTimeAgo(DateTime time) {
    return time.formatTimeAgo;
  }

}