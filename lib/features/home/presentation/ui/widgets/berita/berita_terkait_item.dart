// Widget untuk berita terkait
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mediaexplant/features/home/models/berita.dart';
import 'package:mediaexplant/features/home/presentation/ui/screens/detail_berita_screen.dart';
import 'package:provider/provider.dart';

class BeritaTerkaitItem extends StatelessWidget {
  const BeritaTerkaitItem({super.key});

  @override
  Widget build(BuildContext context) {
    final berita = Provider.of<Berita>(context);
    return Container(
      margin: const EdgeInsets.only(right: 5),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Colors.white,
        child: SizedBox(
          width: 160,
          height: 150,
          child: Stack(
            children: [
              Column(
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(15)),
                    child: SizedBox(
                      width: double.infinity,
                      height: 70,
                      child: CachedNetworkImage(
                        imageUrl: berita.gambar ??
                            berita.firstImageFromKonten ??
                            'https://via.placeholder.com/150',
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                          child:
                              CircularProgressIndicator(), // Indikator loading
                        ),
                        errorWidget: (context, url, error) => const Center(
                          child: Icon(Icons.broken_image,
                              size: 50, color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      berita.judul,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Positioned.fill(
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
                            pageBuilder: (context, animation,
                                    secondaryAnimation) =>
                                ChangeNotifierProvider.value(
                                    value: berita, 
                                    child: DetailBeritaScreen()),
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
                    borderRadius: BorderRadius.circular(10), // Warna highlight
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
