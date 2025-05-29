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
