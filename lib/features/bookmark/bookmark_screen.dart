import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:news_app/features/home/widgets/news_card.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  /// TODO : Task - Make it shared and make it extension
  String _formatTimeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bookmarks')),
      body: ValueListenableBuilder(
        /// TODO : Task - Don't Add Hard Coded Values
        valueListenable: Hive.box('bookmarks').listenable(),
        builder: (context, Box box, _) {
          if (box.isEmpty) {
            return const Center(child: Text('No bookmarked articles yet'));
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final article = box.getAt(index);
              return NewsCard(
                article: article,
                isBookmarked: true,
                onBookmarkPressed: () {
                  box.deleteAt(index);
                },
                formatTimeAgo: _formatTimeAgo,
              );
            },
          );
        },
      ),
    );
  }
}
