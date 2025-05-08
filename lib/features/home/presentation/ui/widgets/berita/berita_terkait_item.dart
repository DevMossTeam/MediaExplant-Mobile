// Widget untuk berita terkait
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mediaexplant/features/home/models/berita/berita.dart';
import 'package:mediaexplant/features/home/presentation/ui/screens/detail_berita_screen.dart';
import 'package:page_transition/page_transition.dart';
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
                        Navigator.of(context).pushAndRemoveUntil(
                          PageTransition(
                            type: PageTransitionType.rightToLeftWithFade,
                            duration: const Duration(milliseconds: 1000),
                            reverseDuration: const Duration(milliseconds: 500),
                            child: ChangeNotifierProvider.value(
                              value: berita,
                              child: DetailBeritaScreen(),
                            ),
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
