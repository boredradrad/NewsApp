import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

void main() => runApp(const NewsApp());

class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: NewsHomePage(), debugShowCheckedModeBanner: false);
  }
}

class NewsHomePage extends StatelessWidget {
  final List<String> categories = [
    "business",
    "entertainment",
    "general",
    "health",
    "science",
    "sports",
    "technology",
  ];

  final List<String> imageUrls = List.generate(
    6,
    (index) =>
        "https://s.yimg.com/ny/api/res/1.2/J5hwSabWRSppRTQq.v4oPw--/YXBwaWQ9aGlnaGxhbmRlcjt3PTEyMDA7aD02MDA-/https://media.zenfs.com/en/the_wall_street_journal_hosted_996/b895364322819a9399fbdc0dae1b55c6",
  );

  final String title = "Israeli airstrike rocks southern Beirut after military...";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
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
                          colors: [
                            Colors.black.withValues(alpha: 0.1),
                            Colors.transparent,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: const Text(
                              'NEWST',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFC53030),
                                fontFamily: 'ScheherazadeNew',
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'Trending News',
                                style: TextStyle(
                                  color: Color(0xFFFFFCFC),
                                  fontSize: 20,
                                  fontFamily: 'ScheherazadeNew',
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              Text(
                                'View all',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'ScheherazadeNewMedium',
                                  fontWeight: FontWeight.w400,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 140,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: 3,
                              separatorBuilder: (_, __) => const SizedBox(width: 12),
                              itemBuilder: (context, index) => trendingNewsCard(index),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("Categories", style: TextStyle(fontSize: 18)),
                      Text("View all", style: TextStyle(color: Colors.blue)),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: SizedBox(
                      height: 30,
                      child: ListView.separated(
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final isSelected = index == 0;
                          return Column(
                            children: [
                              Text(
                                categories[index][0].toUpperCase() +
                                    categories[index].substring(1).toLowerCase(),
                                style: TextStyle(
                                  fontWeight:
                                      isSelected ? FontWeight.bold : FontWeight.normal,
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
                          );
                        },
                      ),
                    ),
                  ),

                  ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: imageUrls.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder:
                        (context, index) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CachedNetworkImage(
                            imageUrl: imageUrls[index % imageUrls.length],
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            placeholder:
                                (context, url) => Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.image),
                                ),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                          ),
                          title: Text(
                            title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Row(
                            children: const [
                              CircleAvatar(
                                radius: 10,
                                backgroundImage: NetworkImage(
                                  "https://s.yimg.com/ny/api/res/1.2/J5hwSabWRSppRTQq.v4oPw--/YXBwaWQ9aGlnaGxhbmRlcjt3PTEyMDA7aD02MDA-/https://media.zenfs.com/en/the_wall_street_journal_hosted_996/b895364322819a9399fbdc0dae1b55c6",
                                ),
                              ),
                              SizedBox(width: 6),
                              Text("CNN News"),
                              SizedBox(width: 12),
                              Text("2 h ago"),
                            ],
                          ),
                          trailing: const Icon(Icons.bookmark_border),
                        ),
                  ),
                ],
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

  Widget trendingNewsCard(int index) {
    final imageUrls = List.generate(
      6,
      (i) =>
          "https://s.yimg.com/ny/api/res/1.2/J5hwSabWRSppRTQq.v4oPw--/YXBwaWQ9aGlnaGxhbmRlcjt3PTEyMDA7aD02MDA-/https://media.zenfs.com/en/the_wall_street_journal_hosted_996/b895364322819a9399fbdc0dae1b55c6",
    );

    const title = "Israeli airstrike rocks southern Beirut after military...";

    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(
            imageUrl: imageUrls[index % imageUrls.length],
            height: 180,
            width: 280,
            fit: BoxFit.cover,
            placeholder:
                (context, url) => Container(
                  color: Colors.grey[300],
                  child: const Center(child: Icon(Icons.image)),
                ),
          ),
        ),
        Positioned(
          left: 12,
          bottom: 12,
          right: 12,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                children: const [
                  CircleAvatar(
                    radius: 10,
                    backgroundImage: NetworkImage(
                      "https://s.yimg.com/ny/api/res/1.2/J5hwSabWRSppRTQq.v4oPw--/YXBwaWQ9aGlnaGxhbmRlcjt3PTEyMDA7aD02MDA-/https://media.zenfs.com/en/the_wall_street_journal_hosted_996/b895364322819a9399fbdc0dae1b55c6",
                    ),
                  ),
                  SizedBox(width: 6),
                  Text("CNN News", style: TextStyle(color: Colors.white, fontSize: 12)),
                  SizedBox(width: 12),
                  Text(
                    "2 hours ago",
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
