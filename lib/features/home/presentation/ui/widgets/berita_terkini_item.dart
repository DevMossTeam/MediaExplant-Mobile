import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mediaexplant/core/constants/app_colors.dart';
import 'package:mediaexplant/features/bookmark/provider/bookmark_provider.dart';
import 'package:mediaexplant/features/home/data/models/berita.dart';
import 'package:mediaexplant/features/home/presentation/ui/screens/detail_berita_screen.dart';
import 'package:provider/provider.dart';

class BeritaTerkiniItem extends StatelessWidget {
  const BeritaTerkiniItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final berita = Provider.of<Berita>(context);
    final bookmarkProvider =
        Provider.of<BookmarkProvider>(context, listen: false);
    return SizedBox(
      height: 280,
      width: double.infinity,
      child: Center(
        child: Stack(
          children: [
            Card(
              color: Colors.amber,
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  child: CachedNetworkImage(
                    height: double.infinity,
                    width: double.infinity,
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
            ),

            // konten
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Container(
                  height: 170,
                  decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(5)),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [AppColors.primary, Colors.transparent],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "${berita.kategori} | ${berita.tanggalDibuat} yang lalu",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                        Text(
                          berita.judul,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Positioned.fill(
                child: Material(
                  color: Colors.transparent, // Hindari warna latar belakang
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
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    DetailBeritaScreen(berita: berita),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              // Animasi geser + fade
                              return SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(
                                      1.0, 0.0), // Mulai dari kanan
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
                    splashColor: Colors.black.withAlpha(100),
                    highlightColor: Colors.white.withAlpha(100),
                    borderRadius: BorderRadius.circular(5), // Warna highlight
                  ),
                ),
              ),
            ),
            Positioned(
              top: 30,
              right: 30,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(100),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () {
                    // Toggle bookmark melalui provider
                    bookmarkProvider.toggleBookmark(
                        userId: "ovPHOkUBw3FHrq6PeQkg1McfBqkF",
                        beritaId: berita.idBerita,
                        berita: berita);
                  },
                  icon: (berita.isBookmark)
                      ? const Icon(Icons.bookmark)
                      : const Icon(Icons.bookmark_outline),
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
