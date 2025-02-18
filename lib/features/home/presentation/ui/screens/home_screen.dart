import 'package:flutter/material.dart';
import 'home_popular_screen.dart';
import 'home_latest_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Dua tab: Popular & Latest
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Beranda'),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Popular'),
              Tab(text: 'Latest'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            HomePopularScreen(),
            HomeLatestScreen(),
          ],
        ),
      ),
    );
  }
}