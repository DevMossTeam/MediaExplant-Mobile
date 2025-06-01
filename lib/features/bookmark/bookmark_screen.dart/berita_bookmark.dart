import 'package:flutter/material.dart';
import 'package:mediaexplant/features/bookmark/viewmodel/berita_bookamark_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita/berita_populer_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita/shimmer_berita.item.dart';
import 'package:provider/provider.dart';

class BeritaBookmark extends StatefulWidget {
  const BeritaBookmark({super.key});

  @override
  State<BeritaBookmark> createState() => _BeritaBookmarkState();
}

class _BeritaBookmarkState extends State<BeritaBookmark> {
  // bool _isInit = true;
  final Map<String, bool> _isLoading = {
    'berita': false,
  };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // if (_isInit) {
    //   _fetchBeritaBookmark();
    //   _isInit = false;
    // }
  }

  // Future<void> _fetchBeritaBookmark() async {
  //   final beritaBookmarkVM =
  //       Provider.of<BeritaBookamarkViewmodel>(context, listen: false);

  //   if (beritaBookmarkVM.allBerita.isEmpty) {
  //     setState(() => _isLoading['berita'] = true);
  //     try {
  //       await beritaBookmarkVM.refresh(userLogin);
  //     } catch (e) {
  //       debugPrint('Error saat fetch berita bookmark: $e');
  //     } finally {
  //       setState(() => _isLoading['berita'] = false);
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final beritaBookmark =
        Provider.of<BeritaBookamarkViewmodel>(context).allBerita;

    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(child: SizedBox(height: 10)),
        if (_isLoading['berita']!)
          const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()))
        else if (beritaBookmark.isEmpty)
          const SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Text(
                  'Belum ada berita yang dibookmark.',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          )
        else
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => ChangeNotifierProvider.value(
                value: beritaBookmark[index],
                child: const BeritaPopulerItem(),
              ),
              childCount: beritaBookmark.length,
            ),
          ),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
      ],
    );
  }
}
