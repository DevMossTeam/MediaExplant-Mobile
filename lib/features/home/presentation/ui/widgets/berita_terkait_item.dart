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
      margin: const EdgeInsets.only(right: 5),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Colors.white,
        child: Container(
          width: 160,
          height: 150,
          child: Stack(
            children: [
              Column(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                    child: Container(
                      width: double.infinity,
                      height: 70,
                      child: Image.network(
                        berita.gambar,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding:const EdgeInsets.symmetric(horizontal: 10),
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
                    onTap: onTap,
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
