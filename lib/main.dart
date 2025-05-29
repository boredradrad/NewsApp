import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const NewsApp());

class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: NewsHomePage(), debugShowCheckedModeBanner: false);
  }
}

class NewsArticle {
  final String title;
  final String urlToImage;
  final String sourceName;
  final DateTime publishedAt;

  NewsArticle({
    required this.title,
    required this.urlToImage,
    required this.sourceName,
    required this.publishedAt,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] ?? '',
      urlToImage: json['urlToImage'] ?? 'https://via.placeholder.com/150',
      sourceName: json['source']['name'] ?? 'Unknown',
      publishedAt: DateTime.tryParse(json['publishedAt'] ?? '') ?? DateTime.now(),
    );
  }
}

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

class NewsHomePage extends StatefulWidget {
  const NewsHomePage({super.key});

  @override
  State<NewsHomePage> createState() => _NewsHomePageState();
}

class _NewsHomePageState extends State<NewsHomePage> {
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
          SliverToBoxAdapter(child: _buildBannerAndTrending()),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: _buildCategories(),
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

  Widget _buildCategories() {
    return SizedBox(
      height: 30,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = selectedCategory == cat;
          return GestureDetector(
            onTap: () {
              setState(() => selectedCategory = cat);
              _loadNews();
            },
            child: Column(
              children: [
                Text(
                  cat[0].toUpperCase() + cat.substring(1),
                  style: TextStyle(
                    color: isSelected ? Colors.red : Colors.black,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                if (isSelected)
                  Container(
                    height: 2,
                    width: 30,
                    color: Colors.red,
                    margin: const EdgeInsets.only(top: 4),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBannerAndTrending() {
    return SizedBox(
      height: 330,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image(
              image: AssetImage('assets/images/background.png'),
              height: 240,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              padding: const EdgeInsets.only(top: 60, left: 16, right: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.3), Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'NEWST',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFC53030),
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Trending News',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      Text(
                        'View all',
                        style: TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _isLoadingHeadlines
                      ? const Center(child: CircularProgressIndicator())
                      : SizedBox(
                        height: 140,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _topHeadlines.take(3).length,
                          separatorBuilder: (_, __) => const SizedBox(width: 12),
                          itemBuilder: (_, index) {
                            final article = _topHeadlines[index];
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Stack(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: article.urlToImage,
                                    height: 180,
                                    width: 280,
                                    fit: BoxFit.cover,
                                    placeholder: (_, __) => const Icon(Icons.image),
                                    errorWidget: (_, __, ___) => const Icon(Icons.error),
                                  ),
                                  Positioned(
                                    left: 12,
                                    bottom: 12,
                                    right: 12,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          article.title,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 10,
                                              backgroundImage: NetworkImage(
                                                article.urlToImage,
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              article.sourceName,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              _formatTimeAgo(article.publishedAt),
                                              style: const TextStyle(
                                                color: Colors.white70,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
