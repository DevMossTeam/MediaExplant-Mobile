// Widget untuk berita terkait
import 'package:flutter/material.dart';
import 'package:mediaexplant/features/home/data/models/berita.dart';
import 'package:provider/provider.dart';

class BeritaTerkaitItem extends StatelessWidget {
  // final Berita berita;
  final VoidCallback onTap; // Callback untuk event klik
  const BeritaTerkaitItem({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final berita = Provider.of<Berita>(context);
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 10),
      child: Stack(
        children: [
          Column(
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
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent, // Hindari warna latar belakang
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
