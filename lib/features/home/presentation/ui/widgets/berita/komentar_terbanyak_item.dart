import 'package:flutter/material.dart';
import 'package:mediaexplant/core/constants/app_colors.dart';
import 'package:mediaexplant/features/home/models/berita.dart';
import 'package:mediaexplant/features/home/presentation/ui/screens/detail_berita_screen.dart';
import 'package:provider/provider.dart';

class KomentarTerbanyakItem extends StatelessWidget {
  const KomentarTerbanyakItem({super.key});

  @override
  Widget build(BuildContext context) {
    final berita = Provider.of<Berita>(context);
    return Column(
      children: [
        const Divider(color: Colors.grey, thickness: 0.5),
        Container(
          // color: Colors.white,
          // margin: const EdgeInsets.symmetric(vertical: 2),
          child: Stack(
            children: [
              Row(
                children: [
                  const Stack(
                    children: [
                      Icon(
                        Icons.messenger,
                        color: AppColors.primary,
                        size: 100,
                      ),
                      Positioned.fill(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "843",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Komentar",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(width: 10),

                  // Judul & Tanggal
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          berita.judul,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${berita.tanggalDibuat} yang lalu",
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  // const SizedBox(
                  //   width: 50,
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
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
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
                    borderRadius: BorderRadius.circular(10),
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
              //       berita.statusBookmark();
              //     },
              //   ),
              // )
            ],
          ),
        ),
      ],
    );
  }
}
