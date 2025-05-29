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
      title: json['title'] ?? 'No Title',
      urlToImage: json['urlToImage'] ?? 'https://via.placeholder.com/150',
      sourceName: json['source']['name'] ?? 'Unknown Source',
      publishedAt: DateTime.parse(json['publishedAt']),
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
      final articles = data['articles'] as List;
      return articles.map((e) => NewsArticle.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load news');
    }
  }
}

class NewsHomePage extends StatefulWidget {
  const NewsHomePage({super.key});

  @override
  State<NewsHomePage> createState() => _NewsHomePageState();
}

class _NewsHomePageState extends State<NewsHomePage> {
  final NewsService _newsService = NewsService();
  List<NewsArticle> _articles = [];
  bool _isLoading = true;
  String selectedCategory = 'general';

  final List<String> categories = [
    "business",
    "entertainment",
    "general",
    "health",
    "science",
    "sports",
    "technology",
  ];

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  Future<void> _loadNews() async {
    setState(() => _isLoading = true);
    try {
      final articles = await _newsService.fetchTopHeadlines(category: selectedCategory);
      setState(() => _articles = articles);
    } catch (_) {
      setState(() => _articles = []);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _onCategoryTap(String category) {
    setState(() => selectedCategory = category);
    _loadNews();
  }

  String _formatTimeAgo(DateTime time) {
    final duration = DateTime.now().difference(time);
    if (duration.inMinutes < 60) return '${duration.inMinutes}m ago';
    if (duration.inHours < 24) return '${duration.inHours}h ago';
    return '${duration.inDays}d ago';
  }

  Widget trendingNewsCard(NewsArticle article) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(
            imageUrl: article.urlToImage,
            height: 180,
            width: 280,
            fit: BoxFit.cover,
            placeholder:
                (context, url) => Container(
                  color: Colors.grey[300],
                  child: const Center(child: Icon(Icons.image)),
                ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
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
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const CircleAvatar(
                    radius: 10,
                    backgroundImage: NetworkImage("https://via.placeholder.com/100"),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    article.sourceName,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _formatTimeAgo(article.publishedAt),
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header and Trending News
                    Container(
                      height: 330,
                      child: Stack(
                        children: [
                          Container(
                            height: 240,
                            width: double.infinity,
                            color: Colors.black12,
                            child: const Center(child: Text('News Banner')),
                          ),
                          Positioned.fill(
                            child: Container(
                              padding: const EdgeInsets.only(
                                top: 60,
                                left: 16,
                                right: 16,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.black.withOpacity(0.3),
                                    Colors.transparent,
                                  ],
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
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        'View all',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  SizedBox(
                                    height: 140,
                                    child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: _articles.take(3).length,
                                      separatorBuilder:
                                          (_, __) => const SizedBox(width: 12),
                                      itemBuilder:
                                          (_, index) =>
                                              trendingNewsCard(_articles[index]),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Categories
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text("Categories", style: TextStyle(fontSize: 18)),
                              Text("View all", style: TextStyle(color: Colors.blue)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 30,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: categories.length,
                              separatorBuilder: (_, __) => const SizedBox(width: 12),
                              itemBuilder: (context, index) {
                                final category = categories[index];
                                final isSelected = category == selectedCategory;
                                return GestureDetector(
                                  onTap: () => _onCategoryTap(category),
                                  child: Column(
                                    children: [
                                      Text(
                                        category[0].toUpperCase() +
                                            category.substring(1).toLowerCase(),
                                        style: TextStyle(
                                          fontWeight:
                                              isSelected
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                          color: isSelected ? Colors.red : Colors.black,
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
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // News List
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _articles.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (_, index) {
                          final article = _articles[index];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CachedNetworkImage(
                              imageUrl: article.urlToImage,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              placeholder:
                                  (_, __) => Container(
                                    width: 80,
                                    height: 80,
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.image),
                                  ),
                              errorWidget: (_, __, ___) => const Icon(Icons.error),
                            ),
                            title: Text(
                              article.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Row(
                              children: [
                                const CircleAvatar(
                                  radius: 10,
                                  backgroundImage: NetworkImage(
                                    "https://via.placeholder.com/100",
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(article.sourceName),
                                const SizedBox(width: 12),
                                Text(_formatTimeAgo(article.publishedAt)),
                              ],
                            ),
                            trailing: const Icon(Icons.bookmark_border),
                          );
                        },
                      ),
                    ),
                  ],
                ),
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
