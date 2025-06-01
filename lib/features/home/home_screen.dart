import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:news_app/core/components/news_card.dart';
import 'package:news_app/core/constants/hive_key.dart';
import 'package:news_app/core/datasource/remote_data/api_service.dart';
import 'package:news_app/core/extentions/extensions.dart';
import 'package:news_app/core/service_locator.dart';
import 'package:news_app/features/home/models/news_article_model.dart';
import 'package:news_app/features/home/repositories/base_news_api_repository.dart';
import 'package:news_app/features/home/repositories/news_api_repository.dart';
import 'package:news_app/features/home/widgets/category_list_widget.dart';
import 'package:news_app/features/home/widgets/trending_news_widget.dart';
import 'package:provider/provider.dart';

import 'home_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  /// TODO-Done : Task - Make Provider For This
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeController>(
      create: (context) =>
      HomeController()
        ..init(),
      child: Scaffold(
        body: Consumer<HomeController>(
          builder: (BuildContext context, HomeController controller,
              Widget? child) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: TrendingNews(
                    isLoading: controller.isLoadingHeadlines,
                    articles: controller.topHeadlines,
                    formatTimeAgo: controller.formatTimeAgo,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: CategoryList(
                      categories: controller.categories,
                      selectedCategory: controller.selectedCategory,
                      onCategorySelected: (category) {
                        setState(() => controller.selectedCategory = category);
                        controller.loadNews();
                      },
                    ),
                  ),
                ),
                controller.isLoadingEverything
                    ? SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Theme
                            .of(context)
                            .colorScheme
                            .primary,
                      ),
                    ),
                  ),
                )
                    : SliverToBoxAdapter(
                  child: ValueListenableBuilder(
                    valueListenable: Hive.box(HiveKey.bookmarks).listenable(),
                    builder: (context, Box box, _) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.everythingArticles.length,
                        itemBuilder: (context, index) {
                          final article = controller.everythingArticles[index];
                          final isBookmarked = box.containsKey(article.url);
                          return NewsCard(
                            article: article,
                            isBookmarked: isBookmarked,
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}