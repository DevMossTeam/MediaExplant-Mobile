import 'package:flutter/material.dart';
import 'package:mediaexplant/features/home/data/models/berita.dart';
import 'package:provider/provider.dart';

class BeritaPopulerItem extends StatelessWidget {
  // final Berita berita;
  final VoidCallback onTap; // Callback untuk event klik
  const BeritaPopulerItem({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final berita = Provider.of<Berita>(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Gambar Berita
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  berita.gambar,
                  width: 120,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),

              // Judul & Tanggal
              Expanded(
                child: SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        berita.judul,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${berita.tanggalDibuat} yang lalu",
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),

              // Bookmark Icon
              IconButton(
                icon: (berita.isBookmark ?? false)
                    ? const Icon(Icons.bookmark)
                    : const Icon(Icons.bookmark_outline),
                color: Colors.black54,
                onPressed: () {
                  berita.statusBookmark();
                },
              ),
            ],
          ),

          // InkWell di atas semua elemen
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                onTap: onTap,
                splashColor: Colors.black.withAlpha(50),
                highlightColor: Colors.white.withAlpha(100),
                borderRadius: BorderRadius.circular(10), // Warna highlight
              ),
            ),
          ),
        ],
      ),
    );
  }
}
