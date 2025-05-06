import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mediaexplant/core/constants/app_colors.dart';
import 'package:mediaexplant/features/home/models/berita/berita.dart';
import 'package:mediaexplant/features/home/presentation/ui/screens/detail_berita_screen.dart';
import 'package:provider/provider.dart';

class BeritaPopulerItem extends StatelessWidget {
  const BeritaPopulerItem({super.key});

  @override
  Widget build(BuildContext context) {
    final berita = Provider.of<Berita>(context);
    // final bookmarkProvider =
    //     Provider.of<BookmarkProvider>(context, listen: false);
    return Container(
      // width: double.infinity,
      height: 70,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Gambar Berita
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: AspectRatio(
                  aspectRatio: 16 / 8,
                  child: CachedNetworkImage(
                    imageUrl: berita.gambar ??
                        berita.firstImageFromKonten ??
                        'https://via.placeholder.com/150',
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(), // Indikator loading
                    ),
                    errorWidget: (context, url, error) => const Center(
                      child:
                          Icon(Icons.broken_image, size: 50, color: Colors.red),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Judul & Tanggal
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          "${berita.kategori} | ",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: AppColors.primary),
                        ),
                        Text(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          "${berita.tanggalDibuat}",
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
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
              //   width:30,
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
                    // Delay efek splash
                    Navigator.of(context).pushAndRemoveUntil(
                      PageRouteBuilder(
                        transitionDuration: const Duration(
                            milliseconds: 1000), // Durasi animasi masuk
                        reverseTransitionDuration: const Duration(
                            milliseconds: 500), // Durasi animasi balik
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            ChangeNotifierProvider.value(
                                value: berita, child: DetailBeritaScreen()),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          // Animasi geser + fade
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(1.0, 0.0), // Mulai dari kanan
                              end: Offset.zero, // Berhenti di tengah
                            ).animate(CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeInOutCubic, // Lebih smooth
                            )),
                            child: FadeTransition(
                              opacity:
                                  animation, // Efek fade kecil agar lebih lembut
                              child: child,
                            ),
                          );
                        },
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
    );
  }
}
