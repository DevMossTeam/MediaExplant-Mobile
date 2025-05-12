import 'package:flutter/material.dart';
import 'package:mediaexplant/core/utils/time_ago_util.dart';
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
                          style: TextStyle(
                            color: Colors.black.withAlpha(150),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          timeAgoFormat(
                              DateTime.parse(widget.comment.tanggalKomentar)),
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),

                    Text(
                      widget.comment.isiKomentar,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 5),

              
                    GestureDetector(
                      onTap: widget.onReply,
                      child: const Text(
                        "Balas",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
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
