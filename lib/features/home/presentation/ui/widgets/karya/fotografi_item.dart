import 'package:flutter/material.dart';
import 'package:mediaexplant/core/constants/app_colors.dart';
import 'package:mediaexplant/features/home/models/karya/karya.dart';
import 'package:mediaexplant/features/home/presentation/ui/screens/detail_karya_screen.dart';

import 'package:provider/provider.dart';

class FotografiItem extends StatelessWidget {
  const FotografiItem({super.key});

  @override
  Widget build(BuildContext context) {
    final karya = Provider.of<Karya>(context);
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
                    child: karya.media.isNotEmpty
                        ? Image.memory(
                            karya.gambar(),
                            fit: BoxFit.cover,
                          )
                        : const Center(child: CircularProgressIndicator()),
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
                        karya.kategori,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: AppColors.primary),
                      ),
                      Text(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        karya.release,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        karya.judul,
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
                            value: karya,
                            child: DetailKaryaScreen(
                              idKarya: karya.idKarya,
                              kategori: karya.kategori,
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
