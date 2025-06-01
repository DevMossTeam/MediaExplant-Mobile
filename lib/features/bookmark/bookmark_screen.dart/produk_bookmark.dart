import 'package:flutter/material.dart';
import 'package:mediaexplant/core/utils/userID.dart';
import 'package:mediaexplant/features/bookmark/viewmodel/produk_bookmark_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita/shimmer_berita.item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/produk/produk_selengkapnya_item.dart';
import 'package:provider/provider.dart';

class ProdukBookmark extends StatefulWidget {
  const ProdukBookmark({super.key});

  @override
  State<ProdukBookmark> createState() => _ProdukBookmarkState();
}

class _ProdukBookmarkState extends State<ProdukBookmark> {
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _fetchProdukBookmark();
      _isInit = false;
    }
  }

  Future<void> _fetchProdukBookmark() async {
    final ProdukBookmarkVM =
        Provider.of<ProdukBookmarkViewmodel>(context, listen: false);
    if (ProdukBookmarkVM.allProduk.isEmpty) {
      if (mounted) setState(() => _isLoading = true);
      try {
        await ProdukBookmarkVM.refresh(userLogin);
      } catch (e) {
        debugPrint('Error saat fetch produk bookmark: $e');
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final produkList = Provider.of<ProdukBookmarkViewmodel>(context).allProduk;

    return RefreshIndicator(
      onRefresh: _fetchProdukBookmark,
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
          else if (produkList.isEmpty)
            const SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Text(
                    'Belum ada Produk yang dibookmark.',
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
                  value: produkList[index],
                  child: ProdukSelengkapnyaItem(),
                ),
                childCount: produkList.length,
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
