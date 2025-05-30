import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:news_app/features/home/models/news_article_model.dart';

class NewsCard extends StatelessWidget {
  final NewsArticle article;
  final bool isBookmarked;
  final Function()? onBookmarkPressed;
  final String Function(DateTime) formatTimeAgo;

  const NewsCard({
    super.key,
    required this.article,
    this.isBookmarked = false,
    this.onBookmarkPressed,
    required this.formatTimeAgo,
  });

  @override
  Widget build(BuildContext context) {
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
            CircleAvatar(radius: 10, backgroundImage: NetworkImage(article.urlToImage)),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                article.sourceName,
                style: Theme.of(context).textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              formatTimeAgo(article.publishedAt),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(
            isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            color:
                isBookmarked
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).iconTheme.color,
          ),
          onPressed: () {
            if (onBookmarkPressed != null) {
              onBookmarkPressed!();
            } else {
              final box = Hive.box('bookmarks');
              if (isBookmarked) {
                box.delete(article.url);
              } else {
                box.put(article.url, article);
              }
            }
          },
        ),
      ),
    );
  }
}
