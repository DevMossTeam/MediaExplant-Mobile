import 'package:flutter/material.dart';
import 'package:mediaexplant/core/constants/app_colors.dart';
import 'home_popular_screen.dart';
import 'home_latest_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Text(
              'MediaExplant',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            bottom: const TabBar(
              labelColor: AppColors.primary,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppColors.primary,
              isScrollable: false,
              labelStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
              tabs: [
                Tab(
                  text: 'Untuk Anda',
                ),
                Tab(text: 'Berita'),
                Tab(
                  text: 'Produk',
                ),
                Tab(text: 'Karya'),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              HomeLatestScreen(),
              HomePopularScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
