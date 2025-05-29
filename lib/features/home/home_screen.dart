import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app/features/home/models/news_article_model.dart';
import 'package:news_app/features/home/services/news_service.dart';
import 'package:news_app/features/home/widgets/category_list_widget.dart';
import 'package:news_app/features/home/widgets/trending_news_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _service = NewsService();
  List<NewsArticle> _topHeadlines = [];
  List<NewsArticle> _everythingArticles = [];
  bool _isLoadingHeadlines = true;
  bool _isLoadingEverything = true;
  String selectedCategory = 'general';

  final List<String> categories = [
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
      final headlines = await _service.fetchTopHeadlines(category: selectedCategory);
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
      final everything = await _service.fetchEverything(query: selectedCategory);
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
              ? const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(top: 32),
                  child: Center(child: CircularProgressIndicator()),
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
                        leading: Container(
                          color: Colors.red,
                          child: CachedNetworkImage(
                            imageUrl: article.urlToImage,
                            width: 122,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => const Icon(Icons.image),
                            errorWidget: (_, __, ___) => const Icon(Icons.error),
                          ),
                        ),
                        title: Text(
                          article.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
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
                                style: TextStyle(overflow: TextOverflow.ellipsis),
                              ),
                            ),
                            Text(_formatTimeAgo(article.publishedAt)),
                          ],
                        ),
                        trailing: const Icon(Icons.bookmark_border),
                      ),
                    );
                  },
                ),
              ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.black,
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
