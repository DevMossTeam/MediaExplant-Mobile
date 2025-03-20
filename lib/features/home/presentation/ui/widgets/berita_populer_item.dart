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
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: InkWell(
        onTap: onTap, // Memicu aksi klik
        splashColor: Colors.blue.withAlpha(50), // Warna efek klik
        highlightColor: Colors.blue.withAlpha(100), // Warna saat ditekan
        borderRadius: BorderRadius.circular(10), // Efek ripple mengikuti Card
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Berita
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                berita.gambar,
                width: 120,
                height: 90,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),

            // Judul & Tanggal
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
      ),
    );
  }
}
