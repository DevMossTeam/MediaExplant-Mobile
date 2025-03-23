import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mediaexplant/features/home/data/models/berita.dart';
import 'package:mediaexplant/features/home/presentation/ui/screens/detail_berita_screen.dart';
import 'package:provider/provider.dart';

class BeritaRekomendasiItem extends StatelessWidget {
  const BeritaRekomendasiItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final berita = Provider.of<Berita>(context);
    return SizedBox(
      width: 350,
      height: double.infinity,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            children: [
              // Gambar Berita
              CachedNetworkImage(
                imageUrl: berita.gambar,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(), // Indikator loading
                ),
                errorWidget: (context, url, error) => const Center(
                  child: Icon(Icons.broken_image, size: 50, color: Colors.red),
                ),
              ),

              // Overlay Gradasi untuk Teks
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 90,
                  color: Colors.black.withAlpha(100),
                ),
              ),

              // Konten Teks
              Positioned(
                bottom: 15,
                left: 15,
                right: 15,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${berita.kategori}  |  ${berita.tanggalDibuat}",
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      berita.judul,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              Positioned.fill(
                  child: InkWell(
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
                    splashColor: Colors.black.withAlpha(50),
                    highlightColor: Colors.white.withAlpha(100),
                    borderRadius: BorderRadius.circular(15), // Warna highlight
                  ),
                ),
              )),
              // Ikon Bookmark
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(100),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {
                      berita.statusBookmark();
                    },
                    icon: (berita.isBookmark)
                        ? const Icon(Icons.bookmark)
                        : const Icon(Icons.bookmark_outline),
                    color: Colors.white,
                    iconSize: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
