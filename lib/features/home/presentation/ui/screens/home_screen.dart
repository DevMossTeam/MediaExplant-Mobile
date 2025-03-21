import 'package:flutter/material.dart';
import 'package:mediaexplant/core/constants/app_colors.dart';
import 'home_popular_screen.dart';
import 'home_latest_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'MediaExplant',
            style: TextStyle(fontWeight: FontWeight.bold, color:AppColors.primary,),
          ),
          bottom: const TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor:Colors.grey,
            indicatorColor: AppColors.primary,
            tabs: [
              Tab(
                text: 'Terbaru',
              ),
              Tab(text: 'Popular'),
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
    );
  }
}
