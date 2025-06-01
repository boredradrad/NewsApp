import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:news_app/core/extentions/extensions.dart';
import 'package:news_app/features/home/models/news_article_model.dart';

import '../../core/constants/hive_key.dart';

class NewsDetails extends StatefulWidget {
  final NewsArticle newsArticle;

  const NewsDetails({super.key, required this.newsArticle});

  @override
  State<NewsDetails> createState() => _NewsDetailsState();
}

class _NewsDetailsState extends State<NewsDetails> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('News Details')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Image.network(
              widget.newsArticle.urlToImage ?? '',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
            ),

            const SizedBox(height: 12),
            Text(
              widget.newsArticle.title,
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (widget.newsArticle.urlToImage != null)
                  CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.grey,
                    backgroundImage:
                    NetworkImage(widget.newsArticle.urlToImage!),
                  ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    widget.newsArticle.sourceName,
                    style: Theme.of(context).textTheme.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  widget.newsArticle.publishedAt.formatTimeAgo,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(width: 6),
                const Icon(Icons.share),
                ValueListenableBuilder(
                  valueListenable: Hive.box(HiveKey.bookmarks).listenable(),
                  builder: (context, Box box, _) {
                    final isBookmarked =
                    box.containsKey(widget.newsArticle.url);
                    return IconButton(
                      icon: Icon(
                        isBookmarked
                            ? Icons.bookmark
                            : Icons.bookmark_border,
                        color: isBookmarked
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).iconTheme.color,
                      ),
                      onPressed: () {
                        final box = Hive.box(HiveKey.bookmarks);
                        if (isBookmarked) {
                          box.delete(widget.newsArticle.url);
                        } else {
                          box.put(widget.newsArticle.url, widget.newsArticle);
                        }
                      },
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 12,),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  widget.newsArticle.content,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
