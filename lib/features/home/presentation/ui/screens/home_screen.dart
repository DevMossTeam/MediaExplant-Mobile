import 'package:flutter/material.dart';
import 'package:mediaexplant/core/constants/app_colors.dart';
import 'package:mediaexplant/features/home/presentation/ui/screens/home_berita_screen.dart';
import 'package:mediaexplant/features/home/presentation/ui/screens/home_untuk_anda_screen.dart';

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
            backgroundColor: AppColors.background,
            leading: Padding(
              padding: const EdgeInsets.only(left: 15, top: 5),
              child: Image.asset(
                'assets/images/app_logo.png',
              ),
            ),
            bottom: const TabBar(
              labelColor: AppColors.primary,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppColors.primary,
              isScrollable: false,
              labelStyle: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              tabs: [
                Tab(text: 'Untuk Anda'),
                Tab(text: 'Berita'),
                Tab(text: 'Produk'),
                Tab(text: 'Karya'),
              ],
            ),
          ),
          body: const TabBarView(
            physics: BouncingScrollPhysics(),
            children: [
              HomeUntukAndaScreen(),
              HomeBeritaScreen(),
              Center(child: Text("Produk")), // sementara placeholder
              Center(child: Text("Karya")), // sementara placeholder
            ],
          ),
        ),
      ),
    );
  }
}
