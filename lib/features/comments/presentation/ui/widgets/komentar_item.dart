import 'package:flutter/material.dart';
import 'package:mediaexplant/core/utils/time_ago_util.dart';
import 'package:mediaexplant/features/comments/models/komentar.dart';
import 'package:provider/provider.dart';

class KomentarItem extends StatefulWidget {
  final VoidCallback? onReply;

  const KomentarItem({
    Key? key,
    this.onReply,
  }) : super(key: key);

  @override
  State<KomentarItem> createState() => _KomentarItemState();
}

class _KomentarItemState extends State<KomentarItem> {
  bool showReplies = false;

  @override
  Widget build(BuildContext context) {
    final comment = Provider.of<Komentar>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Foto Profil
                  CircleAvatar(
                    backgroundImage:
                        comment.profil != null && comment.profil!.isNotEmpty
                            ? NetworkImage(comment.profil!)
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
                              comment.username ?? "",
                              style: TextStyle(
                                color: Colors.black.withAlpha(150),
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              timeAgoFormat(
                                  DateTime.parse(comment.tanggalKomentar)),
                              style: const TextStyle(
                                  fontSize: 10, color: Colors.grey),
                            ),
                          ],
                        ),

                        Text(
                          comment.isiKomentar,
                          style: const TextStyle(fontSize: 15),
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
                              children: (comment.childKomentar ?? [])
                                  .map((reply) => ChangeNotifierProvider.value(
                                        value: reply,
                                        child: KomentarItem(
                                          onReply: widget.onReply,
                                        ),
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
          Positioned.fill(
              child: Material(
            color: Colors.transparent,
            child: InkWell(
              highlightColor: Colors.transparent,
              onLongPress: () {
                if (widget.onReply != null) {
                  widget.onReply!();
                }
              },
            ),
          )),
        ],
      ),
    );
  }
}
