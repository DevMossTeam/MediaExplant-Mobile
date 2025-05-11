import 'package:flutter/material.dart';
import 'package:mediaexplant/features/comments/models/komentar.dart';

class KomentarItem extends StatefulWidget {
  final Komentar comment;
  final VoidCallback? onReply;

  const KomentarItem({
    Key? key,
    required this.comment,
    this.onReply,
  }) : super(key: key);

  @override
  State<KomentarItem> createState() => _KomentarItemState();
}

class _KomentarItemState extends State<KomentarItem> {
  bool showReplies = false;

  @override
  Widget build(BuildContext context) {
    final childKomentar = widget.comment.childKomentar ?? [];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Foto Profil
              CircleAvatar(
                backgroundImage: widget.comment.profil != null &&
                        widget.comment.profil!.isNotEmpty
                    ? NetworkImage(widget.comment.profil!)
                    : null,
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
                        Text(
                          widget.comment.username ?? "",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          widget.comment.tanggalKomentar,
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),

                    Text(
                      widget.comment.isiKomentar,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 6),

                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: widget.onReply,
                      child: const Text(
                        "Balas",
                        style: TextStyle(fontSize: 13, color: Colors.blue),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Daftar komentar balasan
                    if (showReplies)
                      Padding(
                        padding: const EdgeInsets.only(left: 32),
                        child: Column(
                          children: childKomentar
                              .map((reply) => KomentarItem(
                                    comment: reply,
                                    onReply: widget.onReply,
                                  ))
                              .toList(),
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
