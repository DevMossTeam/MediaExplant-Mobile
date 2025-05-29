import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mediaexplant/core/constants/app_colors.dart';
import 'package:mediaexplant/core/utils/time_ago_util.dart';
import 'package:mediaexplant/features/home/models/berita/berita.dart';
import 'package:mediaexplant/features/home/presentation/ui/screens/detail_berita_screen.dart';

import 'package:provider/provider.dart';

class BeritaTerbaruItem extends StatelessWidget {
  const BeritaTerbaruItem({super.key});

  @override
  Widget build(BuildContext context) {
    final berita = Provider.of<Berita>(context);
    return Container(
      width: 160,
      height: 150,
      // color: Colors.amber,
      margin: const EdgeInsets.only(right: 10),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: CachedNetworkImage(
                    imageUrl: berita.firstImageFromKonten ??
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
              const SizedBox(height: 5),
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
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                berita.judul,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
                borderRadius: BorderRadius.circular(5), // Warna highlight
              ),
            ),
          ),
        ],
      ),
    );
  }
}
