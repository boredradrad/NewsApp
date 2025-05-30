// home_screen.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app/core/service_locator.dart';
import 'package:news_app/features/home/models/news_article_model.dart';
import 'package:news_app/features/home/repositories/base_news_api_repository.dart';
import 'package:news_app/features/home/widgets/category_list_widget.dart';
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
              : SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: _everythingArticles.length,
                  (context, index) {
                    final article = _everythingArticles[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CachedNetworkImage(
                          imageUrl: article.urlToImage,
                          width: 122,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => const Icon(Icons.image),
                          errorWidget: (_, __, ___) => const Icon(Icons.error),
                        ),
                        title: Text(
                          article.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        subtitle: Row(
                          children: [
                            CircleAvatar(
                              radius: 10,
                              backgroundImage: NetworkImage(article.urlToImage),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                article.sourceName,
                                style: Theme.of(context).textTheme.bodySmall,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              _formatTimeAgo(article.publishedAt),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        trailing: Icon(
                          Icons.bookmark_border,
                          color: Theme.of(context).iconTheme.color,
                        ),
                      ),
                    );
                  },
                ),
              ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark_border), label: 'Bookmark'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}
