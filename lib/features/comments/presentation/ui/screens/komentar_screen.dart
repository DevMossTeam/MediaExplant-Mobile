import 'package:flutter/material.dart';
import 'package:mediaexplant/features/comments/data/models/komentar.dart';
import 'package:mediaexplant/features/comments/presentation/ui/widgets/komentar_item.dart';

class KomentarScreen extends StatefulWidget {
  const KomentarScreen({Key? key}) : super(key: key);

  @override
  _KomentarScreenState createState() => _KomentarScreenState();
}

class _KomentarScreenState extends State<KomentarScreen> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    // Data Dummy Komentar
    List<Komentar> comments = [
      Komentar(
        profileUrl: "",
        username: "Ryyw",
        time: "4 j",
        comment: "apalah ini kelakuan randomnya bikin heran",
        likes: 638,
        replies: 20,
      ),
      Komentar(
        profileUrl: "",
        username: "twofaces",
        comment: "pengen rasanya mokel",
        time: "6 j",
        likes: 281,
        replies: 14,
      ),
      Komentar(
        profileUrl: "",
        username: "gada nama",
        comment: "batuk udah satu bulan gw aseli",
        time: "2 mnt",
        likes: 0,
        replies: 0,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7, // Ukuran awal modal (70% dari layar)
          minChildSize: 0.4, // Ukuran minimal saat di-drag ke bawah
          maxChildSize: 0.95, // Ukuran maksimal saat di-drag ke atas
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
                    // Garis drag di atas modal
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                    // Pencarian & Close Button
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      child: Row(
                        children: [
                          const Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText:
                                    "Cari: reaksi streamer liat selena pheaker",
                                border: InputBorder.none,
                                hintStyle: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),

                    // Jumlah Komentar
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "1.124 komentar",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),

                    // ListView Komentar (Dibungkus dengan Expanded agar fleksibel)
                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController, // Untuk mendukung drag
                        child: Column(
                          children: comments
                              .map((comment) => KomentarItem(comment: comment))
                              .toList(),
                        ),
                      ),
                    ),

                    // Input Komentar
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      color: Colors.white,
                      child: Row(
                        children: [
                          // Emoji
                          IconButton(
                            icon: const Icon(Icons.emoji_emotions_outlined),
                            onPressed: () {},
                          ),

                          // Input TextField (dengan FocusNode agar mendeteksi keyboard)
                          Expanded(
                            child: TextField(
                              controller: _commentController,
                              focusNode: _focusNode,
                              maxLines: null, // Bisa banyak baris
                              keyboardType: TextInputType.multiline,
                              decoration: const InputDecoration(
                                hintText: "Tambahkan komentar...",
                                border: InputBorder.none,
                              ),
                            ),
                          ),

                          // Tombol Kirim
                          IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: () {
                              if (_commentController.text.isNotEmpty) {
                                print(
                                    "Komentar dikirim: ${_commentController.text}");
                                _commentController.clear();
                                _focusNode
                                    .unfocus(); // Sembunyikan keyboard setelah kirim
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
