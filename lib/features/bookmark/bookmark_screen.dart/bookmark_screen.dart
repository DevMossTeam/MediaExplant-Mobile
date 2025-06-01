import 'package:flutter/material.dart';
import 'package:mediaexplant/core/constants/app_colors.dart';
import 'package:mediaexplant/core/utils/userID.dart';
import 'package:mediaexplant/features/bookmark/bookmark_screen.dart/berita_bookmark.dart';
import 'package:mediaexplant/features/bookmark/viewmodel/berita_bookamark_viewmodel.dart';
import 'package:provider/provider.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return; // cegah event ganda

      if (_tabController.index == 0) {
        // Saat tab Berita aktif, panggil refresh
        final beritaBookmarkVM =
            Provider.of<BeritaBookamarkViewmodel>(context, listen: false);
        beritaBookmarkVM.refresh(userLogin);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          bottom: TabBar(
            controller: _tabController,
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.primary,
            isScrollable: false,
            labelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            tabs: const [
              Tab(text: 'Berita'),
              Tab(text: 'Karya'),
              Tab(text: 'Produk'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          physics: const BouncingScrollPhysics(),
          children: const [
            BeritaBookmark(),
            Center(child: Text('Karya Tab')), // placeholder
            Center(child: Text('Produk Tab')), // placeholder
          ],
        ),
      ),
    );
  }
}
