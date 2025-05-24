import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mediaexplant/features/comments/models/komentar.dart';
import 'package:mediaexplant/features/comments/presentation/logic/komentar_viewmodel.dart';
import 'package:mediaexplant/features/comments/presentation/ui/widgets/komentar_item.dart';

class KomentarBottomSheet extends StatefulWidget {
  final String komentarType;
  final String itemId;
  final String? userId;
  const KomentarBottomSheet({
    Key? key,
    required this.komentarType,
    required this.itemId,
    this.userId,
  }) : super(key: key);

  @override
  State<KomentarBottomSheet> createState() => _KomentarBottomSheetState();
}

class _KomentarBottomSheetState extends State<KomentarBottomSheet> {
  final TextEditingController _komentarController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Komentar? _replyTo;
  Set<String> _openedKomentarIds = Set();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<KomentarViewmodel>().fetchKomentar(
            komentarType: widget.komentarType,
            itemId: widget.itemId,
          );
    });
  }

  Map<String?, List<Komentar>> _groupKomentar(List<Komentar> list) {
    final Map<String?, List<Komentar>> map = {};
    for (final komentar in list) {
      final parentId =
          komentar.parentId?.isEmpty ?? true ? null : komentar.parentId;
      map.putIfAbsent(parentId, () => []).add(komentar);
    }
    return map;
  }

  List<Widget> _buildKomentarList(Map<String?, List<Komentar>> map) {
    final parentKomentar = map[null] ?? [];
    List<Widget> widgets = [];

    for (final komentar in parentKomentar) {
      widgets.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Komentar parent
          ChangeNotifierProvider.value(
            value: komentar,
            child: KomentarItem(
              onReply: () {
                setState(() {
                  _replyTo = komentar;
                  _focusNode.requestFocus();
                });
              },
            ),
          ),

          // Tombol lihat balasan jika belum dibuka
          if ((map[komentar.id] ?? []).isNotEmpty &&
              !_openedKomentarIds.contains(komentar.id))
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: Row(
                children: [
                  Container(
                    width: 25,
                    height: 0.5,
                    color: Colors.grey,
                    margin: const EdgeInsets.only(right: 5),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _openedKomentarIds.add(komentar.id);
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Text(
                            'Lihat ${(map[komentar.id] ?? []).length} balasan',
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 12),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.arrow_drop_down,
                            size: 18,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Jika sudah dibuka, tampilkan semua balasan dan tombol sembunyikan
          if (_openedKomentarIds.contains(komentar.id)) ...[
            ..._getAllNestedReplies(komentar.id, map).map(
              (reply) => Padding(
                padding: const EdgeInsets.only(left: 45), // indent
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 62),
                      child: Text(
                        'Balas ${reply.username}',
                        style: const TextStyle(
                          fontSize: 10,
                          // fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    ChangeNotifierProvider.value(
                      value: reply,
                      child: KomentarItem(
                        onReply: () {
                          setState(() {
                            _replyTo = reply;
                            _focusNode.requestFocus();
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),

            // Tombol sembunyikan setelah semua child
            Padding(
              padding: const EdgeInsets.only(left: 60),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Container(
                      width: 25,
                      height: 0.5,
                      color: Colors.grey,
                      margin: const EdgeInsets.only(right: 5),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _openedKomentarIds.remove(komentar.id);
                        });
                      },
                      child: const Text(
                        'Sembunyikan',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_drop_up,
                      size: 18,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ));
    }

    return widgets;
  }

  List<Komentar> _getAllNestedReplies(
      String parentId, Map<String?, List<Komentar>> map) {
    final replies = map[parentId] ?? [];
    List<Komentar> allReplies = [];

    for (final reply in replies) {
      allReplies.add(reply);
      allReplies.addAll(_getAllNestedReplies(
          reply.id, map)); // Ambil balasan child secara rekursif
    }

    return allReplies;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<KomentarViewmodel>(
      builder: (context, komentarVM, _) {
        final komentarMap = _groupKomentar(komentarVM.komentarList);

        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.4,
          maxChildSize: 1.0,
          expand: false,
          builder: (context, scrollController) {
            return AnimatedPadding(
              duration: const Duration(milliseconds: 300),
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Komentar  ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              komentarVM.komentarList.length.toString(),
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.grey),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (komentarVM.isLoading)
                      const Expanded(
                          child: Center(child: CircularProgressIndicator()))
                    else
                      Expanded(
                        child: ListView(
                          physics: const ClampingScrollPhysics(),
                          padding: EdgeInsets.zero,
                          children: _buildKomentarList(komentarMap),
                        ),
                      ),
                    const Divider(
                      thickness: 1,
                    ),
                    Container(
                      padding:
                          const EdgeInsets.only(right: 16, bottom: 5, left: 16),
                      color: Colors.white,
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (_replyTo != null)
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Membalas ${_replyTo!.username}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontStyle: FontStyle.italic,
                                            color: Colors.blueGrey,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.close, size: 18),
                                        onPressed: () =>
                                            setState(() => _replyTo = null),
                                      ),
                                    ],
                                  ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 0),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withAlpha(100),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      maxHeight: 120,
                                    ),
                                    child: TextField(
                                      controller: _komentarController,
                                      focusNode: _focusNode,
                                      maxLines: null,
                                      decoration: const InputDecoration(
                                        hintText: "Tambahkan komentar...",
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                )
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: () async {
                              final isi = _komentarController.text.trim();
                              if (isi.isNotEmpty) {
                                await komentarVM.postKomentar(
                                  userId: widget.userId,
                                  isiKomentar: isi,
                                  komentarType: widget.komentarType,
                                  itemId: widget.itemId,
                                  parentId: _replyTo?.id,
                                );
                                _komentarController.clear();
                                setState(() => _replyTo = null);
                                _focusNode.unfocus();
                                await komentarVM.fetchKomentar(
                                  komentarType: widget.komentarType,
                                  itemId: widget.itemId,
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
