import 'package:flutter/material.dart';
import 'package:mediaexplant/core/utils/userID.dart';
import 'package:mediaexplant/features/bookmark/viewmodel/karya_bookmark_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita/shimmer_berita.item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/karya/karya_selengkapnya_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/karya/puisi_item.dart';
import 'package:provider/provider.dart';

class KaryaBookmark extends StatefulWidget {
  const KaryaBookmark({super.key});

  @override
  State<KaryaBookmark> createState() => _KaryaBookmarkState();
}

class _KaryaBookmarkState extends State<KaryaBookmark> {
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _fetchKaryaBookmark();
      _isInit = false;
    }
  }

  Future<void> _fetchKaryaBookmark() async {
    final karyaBookmarkVM =
        Provider.of<KaryaBookmarkViewmodel>(context, listen: false);
    if (karyaBookmarkVM.allkarya.isEmpty) {
      if (mounted) setState(() => _isLoading = true);
      try {
        await karyaBookmarkVM.refresh(userLogin);
      } catch (e) {
        debugPrint('Error saat fetch karya bookmark: $e');
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final karyaList = Provider.of<KaryaBookmarkViewmodel>(context).allkarya;

    return RefreshIndicator(
      onRefresh: _fetchKaryaBookmark,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          const SliverToBoxAdapter(child: SizedBox(height: 10)),
          if (_isLoading)
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => const ShimmerBeritaItem(),
                childCount: 3,
              ),
            )
          else if (karyaList.isEmpty)
            const SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Text(
                    'Belum ada karya yang dibookmark.',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
          else
            SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) => ChangeNotifierProvider.value(
                  value: karyaList[index],
                  child: KaryaSelengkapnyaItem(),
                ),
                childCount: karyaList.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 5,
                childAspectRatio: 0.55,
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }
}
