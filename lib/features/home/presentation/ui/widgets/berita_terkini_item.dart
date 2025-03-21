import 'package:flutter/material.dart';
import 'package:mediaexplant/core/constants/app_colors.dart';
import 'package:mediaexplant/features/home/data/models/berita.dart';
import 'package:provider/provider.dart';

class BeritaTerkiniItem extends StatelessWidget {
  // final Berita berita;
  final VoidCallback onTap; // Callback untuk event klik

  const BeritaTerkiniItem({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final berita = Provider.of<Berita>(context);
    return SizedBox(
      height: 300,
      child: Stack(
        children: [
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gambar dan Bookmark
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(10)),
                      child: Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: Image.network(
                          berita.gambar,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
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
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(10)),
                      gradient: LinearGradient(
                        colors: [AppColors.primary, Colors.red],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            berita.tanggalDibuat,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            berita.judul,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Positioned.fill(
              child: Material(
                color: Colors.transparent, // Hindari warna latar belakang
                child: InkWell(
                  onTap: onTap,
                  splashColor:Colors.black.withAlpha(50), 
                  highlightColor: Colors.white.withAlpha(100),
                  borderRadius: BorderRadius.circular(10), // Warna highlight
                ),
              ),
            ),
          ),
        ],  
      ),
    );
  }
}
