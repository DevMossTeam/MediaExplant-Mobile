// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mediaexplant/core/utils/userID.dart';
import 'package:provider/provider.dart';

import 'package:mediaexplant/core/utils/time_ago_util.dart';
import 'package:mediaexplant/features/comments/models/komentar.dart';
import 'package:mediaexplant/features/comments/presentation/logic/komentar_viewmodel.dart';

class KomentarItem extends StatefulWidget {
  final VoidCallback? onReply;
  final String? userId;
  const KomentarItem({
    Key? key,
    this.onReply,
    this.userId,
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
                    backgroundImage: comment.profil != null &&
                            comment.profil!.isNotEmpty
                        ? MemoryImage(base64Decode(comment.profil!))
                        : const AssetImage('assets/images/default_avatar.png')
                            as ImageProvider,
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
          if (comment.userId == userLogin)
            Positioned(
              top: 0,
              right: 0,
              child: PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, size: 18),
                onSelected: (value) async {
                  if (value == 'hapus') {
                    final konfirmasi = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Hapus Komentar'),
                        content:
                            const Text('Yakin ingin menghapus komentar ini?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Batal'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Hapus',
                                style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );

                    if (konfirmasi == true) {
                      final sukses = await context
                          .read<KomentarViewmodel>()
                          .deleteKomentar(comment.id ?? '');

                      if (!sukses) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Gagal menghapus komentar')),
                        );
                      }
                    }
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: 'hapus',
                    child: Text('Hapus Komentar'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
