import 'package:flutter/cupertino.dart';

import '../../core/service_locator.dart';
import '../home/models/news_article_model.dart';
import '../home/repositories/base_news_api_repository.dart';

class SearchProvider extends ChangeNotifier{

//   @override
//   State<SearchScreen> createState() => _SearchScreenState();

  List<NewsArticle> articles = [];
  bool isLoading = false;
  String? errorMessage;
  final TextEditingController searchController = TextEditingController();

  Future<void> searchNews(String query) async {
    if (query.isEmpty) {
        articles = [];
        errorMessage = null;
        notifyListeners();
      return;
    }

      isLoading = true;
      errorMessage = null;

    try {
      final repository = locator<BaseNewsApiRepository>();
      final articles = await repository.fetchEverything(query: query);

        this.articles = articles;
        isLoading = false;

    } catch (e) {

        errorMessage = 'Failed to load news: $e';
        isLoading = false;

    } finally{
      notifyListeners();

    }
}
}