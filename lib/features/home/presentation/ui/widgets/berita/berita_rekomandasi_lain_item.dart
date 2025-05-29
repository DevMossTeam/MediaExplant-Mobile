import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mediaexplant/core/constants/app_colors.dart';
import 'package:mediaexplant/core/utils/time_ago_util.dart';
import 'package:mediaexplant/features/home/models/berita/berita.dart';
import 'package:mediaexplant/features/home/presentation/ui/screens/detail_berita_screen.dart';
import 'package:provider/provider.dart';

class BeritaRekomandasiLainItem extends StatelessWidget {
  const BeritaRekomandasiLainItem({super.key});

  @override
  Widget build(BuildContext context) {
    final berita = Provider.of<Berita>(context);
    // final bookmarkProvider =
    //     Provider.of<BookmarkProvider>(context, listen: false);
    return Container(
      margin: const EdgeInsets.only(right: 10),
      // color: Colors.amber,
      width: 250,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: CachedNetworkImage(
                height: double.infinity,
                width: double.infinity,
                imageUrl: berita.firstImageFromKonten ??
                    'https://via.placeholder.com/150',
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(), // Indikator loading
                ),
                errorWidget: (context, url, error) => const Center(
                  child: Icon(Icons.broken_image, size: 50, color: Colors.red),
                ),
              ),
            ),
          ),

          // konten
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 120,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(5)),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [AppColors.primary, Colors.transparent],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "${berita.kategori} | ${timeAgoFormat(DateTime.parse(berita.tanggalDibuat))}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                    ),
                    Text(
                      berita.judul,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent, // Hindari warna latar belakang
              child: InkWell(
                onTap: () {
                  Future.delayed(const Duration(milliseconds: 200), () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider.value(
                          value: berita,
                          child: DetailBeritaScreen(
                            idBerita: berita.idBerita,
                            kategori: berita.kategori,
                          ),
                        ),
                      ),
                      (route) => route.isFirst,
                    );
                  });
                },
                splashColor: Colors.black.withAlpha(100),
                highlightColor: Colors.white.withAlpha(100),
                borderRadius: BorderRadius.circular(5), // Warna highlight
              ),
            ),
          ),
          // Positioned(
          //   top: 15,
          //   right: 15,
          //   child: Container(
          //     width: 40,
          //     height: 40,
          //     decoration: BoxDecoration(
          //       color: Colors.black.withAlpha(100),
          //       shape: BoxShape.circle,
          //     ),
          //     child: IconButton(
          //       onPressed: () {
          //         // Toggle bookmark melalui provider
          //         bookmarkProvider.toggleBookmark(
          //             userId: "ovPHOkUBw3FHrq6PeQkg1McfBqkF",
          //             beritaId: berita.idBerita,
          //             berita: berita);
          //       },
          //       icon: (berita.isBookmark)
          //           ? const Icon(Icons.bookmark)
          //           : const Icon(Icons.bookmark_outline),
          //       color: Colors.white,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
