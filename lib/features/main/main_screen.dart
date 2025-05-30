import 'package:flutter/material.dart';
import 'package:news_app/features/bookmark/bookmark_screen.dart';
import 'package:news_app/features/home/home_screen.dart';
import 'package:news_app/features/profile/profile_screen.dart';
import 'package:news_app/features/search/search_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentScreenIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const SearchScreen(),
    const BookmarkScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            _currentScreenIndex = index;
          });
        },
        currentIndex: _currentScreenIndex,
        items: const [
          /// TODO : Task - Add Svg Picture Instead Of Icons
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark_border), label: 'Bookmark'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
      body: _screens[_currentScreenIndex],
    );
  }
}
