// Widget untuk berita terkait
import 'package:flutter/material.dart';
import 'package:mediaexplant/features/home/data/models/berita.dart';

class BeritaTerkaitItem extends StatelessWidget {
  final Berita berita;
  final VoidCallback onTap; // Callback untuk event klik
  const BeritaTerkaitItem(
      {super.key, required this.berita, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.blue.withAlpha(50), // Warna efek klik
      highlightColor: Colors.blue.withAlpha(100), // Warna saat ditekan
      borderRadius: BorderRadius.circular(10), // Efek ripple mengikuti Card
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(berita.gambar),
                  fit: BoxFit.cover,
                  onError: (error, stackTrace) {
                    // return const AssetImage('assets/ic_placeholder.jpg');
                  },
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              berita.judul,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
