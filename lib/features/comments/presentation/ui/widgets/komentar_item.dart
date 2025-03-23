import 'package:flutter/material.dart';
import 'package:mediaexplant/features/comments/data/models/komentar.dart';

class KomentarItem extends StatelessWidget {
  final Komentar comment;

  const KomentarItem({Key? key, required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Foto Profil
              CircleAvatar(
                backgroundImage: NetworkImage(comment.profileUrl),
                radius: 18,
              ),
              const SizedBox(width: 10),

              // Komentar
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Nama Pengguna
                        Text(
                          comment.username,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 6),

                        // Waktu
                        Text(
                          comment.time,
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Isi Komentar
                    Text(
                      comment.comment,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 6),

                    // Tombol Balas, Like, Dislike
                    Row(
                      children: [
                        // Tombol Balas
                        const Text(
                          "Balas",
                          style: TextStyle(fontSize: 13, color: Colors.blue),
                        ),
                        const SizedBox(width: 10),

                        // Like
                        const Icon(Icons.favorite_border,
                            size: 16, color: Colors.grey),
                        const SizedBox(width: 5),
                        Text(
                          comment.likes.toString(),
                          style: const TextStyle(fontSize: 13, color: Colors.grey),
                        ),

                        const SizedBox(width: 10),

                        // Dislike
                        const Icon(Icons.thumb_down_alt_outlined,
                            size: 16, color: Colors.grey),
                      ],
                    ),

                    // Jika ada balasan, tampilkan "Lihat balasan"
                    if (comment.replies > 0)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          "Lihat ${comment.replies} balasan",
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
