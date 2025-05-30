import 'package:hive/hive.dart';

part 'news_article_model.g.dart';

@HiveType(typeId: 0)
class NewsArticle {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String? urlToImage;

  @HiveField(2)
  final String sourceName;

  @HiveField(3)
  final DateTime publishedAt;

  @HiveField(4)
  final String url;

  NewsArticle({
    required this.title,
    required this.urlToImage,
    required this.sourceName,
    required this.publishedAt,
    required this.url,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] ?? '',
      urlToImage: json['urlToImage'],
      sourceName: json['source']['name'] ?? 'Unknown',
      publishedAt: DateTime.tryParse(json['publishedAt'] ?? '') ?? DateTime.now(),
      url: json['url'] ?? '',
    );
  }
}
