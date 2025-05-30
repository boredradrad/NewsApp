import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:news_app/core/service_locator.dart';
import 'package:news_app/features/home/models/news_article_model.dart';
import 'package:news_app/features/home/repositories/base_news_api_repository.dart';
import 'package:news_app/features/home/widgets/category_list_widget.dart';
import 'package:news_app/features/home/widgets/news_card.dart';
import 'package:news_app/features/home/widgets/trending_news_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final BaseNewsApiRepository _repository = locator<BaseNewsApiRepository>();
  List<NewsArticle> _topHeadlines = [];
  List<NewsArticle> _everythingArticles = [];
  bool _isLoadingHeadlines = true;
  bool _isLoadingEverything = true;
  String selectedCategory = 'Top News';

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

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  /// TODO : Task - Make Provider For This
  Future<void> _loadNews() async {
    setState(() {
      _isLoadingHeadlines = true;
      _isLoadingEverything = true;
    });

    try {
      final headlines = await _repository.fetchTopHeadlines(
        category: selectedCategory == 'Top News' ? 'general' : selectedCategory,
      );
      setState(() {
        _topHeadlines = headlines;
        _isLoadingHeadlines = false;
      });
    } catch (_) {
      setState(() {
        _topHeadlines = [];
        _isLoadingHeadlines = false;
      });
    }

    try {
      final everything = await _repository.fetchEverything(
        query: selectedCategory == 'Top News' ? 'news' : selectedCategory,
      );
      setState(() {
        _everythingArticles = everything;
        _isLoadingEverything = false;
      });
    } catch (_) {
      setState(() {
        _everythingArticles = [];
        _isLoadingEverything = false;
      });
    }
  }

  /// TODO : Task - Make this extension
  String _formatTimeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: TrendingNews(
              isLoading: _isLoadingHeadlines,
              articles: _topHeadlines,
              formatTimeAgo: _formatTimeAgo,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: CategoryList(
                categories: categories,
                selectedCategory: selectedCategory,
                onCategorySelected: (category) {
                  setState(() => selectedCategory = category);
                  _loadNews();
                },
              ),
            ),
          ),
          _isLoadingEverything
              ? SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 32),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              )
              : SliverToBoxAdapter(
                child: ValueListenableBuilder(
                  valueListenable: Hive.box('bookmarks').listenable(),
                  builder: (context, Box box, _) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _everythingArticles.length,
                      itemBuilder: (context, index) {
                        final article = _everythingArticles[index];
                        final isBookmarked = box.containsKey(article.url);
                        return NewsCard(
                          article: article,
                          isBookmarked: isBookmarked,
                          formatTimeAgo: _formatTimeAgo,
                        );
                      },
                    );
                  },
                ),
              ),
        ],
      ),
    );
  }
}
