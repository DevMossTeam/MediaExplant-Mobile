import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mediaexplant/features/home/data/models/berita.dart';
import 'package:provider/provider.dart';

class BeritaRekomendasiItem extends StatelessWidget {
  // final Berita berita;
  final VoidCallback onTap;

  const BeritaRekomendasiItem({
    super.key,
    // required this.berita,
    required this.onTap,
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
                    onTap: onTap,
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
                    icon: (berita.isBookmark ?? false)
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
