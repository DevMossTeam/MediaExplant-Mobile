import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mediaexplant/core/constants/app_colors.dart';
import 'package:mediaexplant/core/utils/time_ago_util.dart';
import 'package:mediaexplant/features/home/models/berita/berita.dart';
import 'package:mediaexplant/features/home/presentation/ui/screens/detail_berita_screen.dart';

import 'package:provider/provider.dart';

class BeritaTeratasUntukAnda extends StatelessWidget {
  const BeritaTeratasUntukAnda({super.key});

  @override
  Widget build(BuildContext context) {
    final berita = Provider.of<Berita>(context);
    // final bookmarkProvider =
    //     Provider.of<BookmarkProvider>(context, listen: false);
    return Container(
      // color: Colors.amber,
      // width: double.infinity,
      // height: 90,
      child: IntrinsicHeight(
        child: Stack(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: AspectRatio(
                    aspectRatio: 5 / 3, // Misalnya 4:3, bisa disesuaikan
                    child: CachedNetworkImage(
                      imageUrl: berita.firstImageFromKonten ??
                          'https://via.placeholder.com/150',
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(), // Indikator loading
                      ),
                      errorWidget: (context, url, error) => const Center(
                        child: Icon(Icons.broken_image,
                            size: 50, color: Colors.red),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // Judul & Tanggal
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        berita.kategori,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: AppColors.primary),
                      ),
                      Text(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        // berita.tanggalDibuat,
                        timeAgoFormat(DateTime.parse(berita.tanggalDibuat)),
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        berita.judul,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                // const SizedBox(
                //   width: 30,
                // )
              ],
            ),

            // InkWell di atas semua elemen
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
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
                  splashColor: Colors.black.withAlpha(50),
                  highlightColor: Colors.white.withAlpha(100),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            // Positioned(
            //   right: 0,
            //   top: 0,
            //   child: IconButton(
            //     icon: (berita.isBookmark)
            //         ? const Icon(Icons.bookmark)
            //         : const Icon(Icons.bookmark_outline),
            //     color: Colors.black54,
            //     onPressed: () {
            //       bookmarkProvider.toggleBookmark(
            //           userId: "ovPHOkUBw3FHrq6PeQkg1McfBqkF",
            //           beritaId: berita.idBerita,
            //           berita: berita);
            //     },
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
