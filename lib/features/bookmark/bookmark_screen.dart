import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:news_app/core/components/news_card.dart';
import 'package:news_app/core/constants/hive_key.dart';
import 'package:news_app/core/extentions/extensions.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  /// TODO-Done : Task - Make it shared and make it extension
  String _formatTimeAgo(DateTime time) {
    return time.formatTimeAgo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bookmarks')),
      body: ValueListenableBuilder(
        /// TODO-Done : Task - Don't Add Hard Coded Values
        valueListenable: Hive.box(HiveKey.bookmarks).listenable(),
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
              );
            },
          );
        },
      ),
    );
  }
}
