import 'package:flutter/material.dart';

void main() {
  runApp(const NewsApp());
}

class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(debugShowCheckedModeBanner: false, home: NewsScreen());
  }
}

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Container(
          //   width: double.infinity,
          //   height: double.infinity,
          //   decoration: BoxDecoration(
          //     image: DecorationImage(
          //       image: AssetImage('assets/images/background.png'),
          //       fit: BoxFit.cover,
          //       colorFilter: ColorFilter.mode(
          //         Colors.black.withOpacity(0.5),
          //         BlendMode.dstATop,
          //       ),
          //     ),
          //   ),
          // ),
          Positioned(
            top: 40,
            left: 16,
            child: Text('NEWST', style: TextStyle(color: Colors.red, fontSize: 24, fontWeight: FontWeight.bold)),
          ),
          // Main Content
          Positioned.fill(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 100), // Space for the "NEWST" title
                  // Trending News Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Trending News',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        TextButton(onPressed: () {}, child: Text('VIEW ALL', style: TextStyle(color: Colors.white))),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: NewsCard(
                            imageUrl: 'https://picsum.photos/200/150?random=2',
                            title: 'City unveils new safety regulations proposal for late...',
                            source: 'CNN News',
                            time: '2 hours ago',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: NewsCard(
                            imageUrl: 'https://picsum.photos/200/150?random=3',
                            title: 'Rain all over the next 3 days with...',
                            source: 'CNN News',
                            time: '2 hours ago',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Categories Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Categories',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        TextButton(onPressed: () {}, child: Text('VIEW ALL', style: TextStyle(color: Colors.white))),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        const SizedBox(width: 16),
                        CategoryTab(label: 'TOP NEWS', isSelected: true),
                        CategoryTab(label: 'Politics', isSelected: false),
                        CategoryTab(label: 'Tech', isSelected: false),
                        CategoryTab(label: 'Business', isSelected: false),
                        CategoryTab(label: 'Sports', isSelected: false),
                        CategoryTab(label: 'To', isSelected: false),
                        TextButton(onPressed: () {}, child: const Text('VIEW ALL')),
                        const SizedBox(width: 16),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Top News List
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return NewsListItem(
                          imageUrl: 'https://picsum.photos/100/100?random=${index + 4}',
                          title: 'Israeli airstrike rocks southern Beirut after milita...',
                          source: 'CNN News',
                          time: '2 h ago',
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

class NewsCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String source;
  final String time;

  const NewsCard({super.key, required this.imageUrl, required this.title, required this.source, required this.time});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(imageUrl, height: 100, width: double.infinity, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('$source  •  $time', style: const TextStyle(color: Colors.grey)),
                const Icon(Icons.bookmark_border),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NewsListItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String source;
  final String time;

  const NewsListItem({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.source,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Image.network(imageUrl, width: 100, height: 100, fit: BoxFit.cover),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text('$source  •  $time', style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          const Icon(Icons.bookmark_border),
        ],
      ),
    );
  }
}

class CategoryTab extends StatelessWidget {
  final String label;
  final bool isSelected;

  const CategoryTab({super.key, required this.label, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8.0),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.red : Colors.white,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          if (isSelected) Container(margin: const EdgeInsets.only(top: 4.0), height: 2, width: 20, color: Colors.red),
        ],
      ),
    );
  }
}
