import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mediaexplant/core/constants/app_colors.dart';
import 'package:mediaexplant/features/home/data/models/berita.dart';
import 'package:mediaexplant/features/comments/presentation/ui/screens/komentar_screen.dart';
import 'package:mediaexplant/features/home/presentation/logic/berita_terkini_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita_populer_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita_terkait_item.dart';
import 'package:provider/provider.dart';

class DetailBeritaScreen extends StatefulWidget {
  final Berita berita;
  const DetailBeritaScreen({super.key, required this.berita});

  @override
  State<DetailBeritaScreen> createState() => _DetailBeritaScreenState();
}

class _DetailBeritaScreenState extends State<DetailBeritaScreen> {
  // Fungsi untuk menghapus gambar pertama dari konten berita
  String removeFirstImageFromKonten(String konten) {
    // Hapus tag <p> yang hanya berisi <img> (bisa ada atribut)
    final RegExp imgInPTag =
        RegExp(r'<p[^>]*>\s*<img[^>]*>\s*</p>', caseSensitive: false);
    konten = konten.replaceFirst(imgInPTag, '');

    // Jika ada <img> yang berdiri sendiri tanpa <p>
    final RegExp standaloneImgTag = RegExp(r'<img[^>]*>', caseSensitive: false);
    konten = konten.replaceFirst(standaloneImgTag, '');

    return konten.trim(); // Menghilangkan whitespace di awal/akhir
  }

  @override
  Widget build(BuildContext context) {
    // Mengubah warna status bar
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.grey,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    final beritaProvider = Provider.of<BeritaTerkiniViewmodel>(context);
    final beritaList = beritaProvider.allBerita;

    String kontenTanpaGambar =
        removeFirstImageFromKonten(widget.berita.kontenBerita);

    // String removeFirstImageFromKonten(String konten) {
    //   final RegExp regExp = RegExp(r'<img[^>]*src="[^"]*"[^>]*>');
    //   return konten.replaceFirst(regExp, '');
    // }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 250, // Tinggi awal sebelum di-scroll
              collapsedHeight: 60, // Tinggi minimum saat di-scroll
              floating: false,
              pinned: true, // Agar tetap terlihat saat di-scroll
              elevation: 0,
              backgroundColor: Colors.transparent,
              flexibleSpace: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: widget.berita.gambar ??
                            widget.berita.firstImageFromKonten ??
                            'https://via.placeholder.com/150',
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => const Center(
                          child: Icon(Icons.broken_image,
                              size: 50, color: Colors.red),
                        ),
                      ),
                    ],
                  );
                },
              ),
              leading: Container(
                margin: const EdgeInsets.only(left: 15),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(100),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              actions: [
                Container(
                  margin: const EdgeInsets.only(right: 20),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(100),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        widget.berita.statusBookmark();
                      });
                    },
                    icon: (widget.berita.isBookmark)
                        ? const Icon(Icons.bookmark, color: Colors.white)
                        : const Icon(Icons.bookmark_outline,
                            color: Colors.white),
                  ),
                ),
              ],
            ),

            // Konten Berita
            SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "mediaExplant",
                            style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            widget.berita.judul,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Oleh: ${widget.berita.penulis}  |  ${widget.berita.tanggalDibuat}',
                            style: const TextStyle(color: Colors.grey),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const Divider(color: Colors.grey, thickness: 0.5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Konten berita HTML
                          Html(
                            data: kontenTanpaGambar,
                            style: {
                              "body": Style(
                                fontSize: FontSize(16),
                                color: Colors.black87,
                                lineHeight: LineHeight.number(1.5),
                              ),
                              "p": Style(
                                margin: Margins.only(bottom: 12),
                              ),
                            },
                          ),

                          const SizedBox(height: 20),
                          const Text(
                            "Berikan Tanggapanmu :",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),

                          // Tombol interaksi
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.thumb_up,
                                  color: widget.berita.isLike
                                      ? Colors.blue
                                      : Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    widget.berita.statusLike();
                                  });
                                },
                              ),
                              Text(
                                '${widget.berita.jumlahLike}',
                                style: const TextStyle(color: Colors.blue),
                              ),
                              const SizedBox(width: 10),

                              // Tombol Dislike
                              IconButton(
                                icon: Icon(
                                  Icons.thumb_down,
                                  color: widget.berita.isDislike
                                      ? Colors.red
                                      : Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    widget.berita.statusDislike();
                                  });
                                },
                              ),
                              Text(
                                '${widget.berita.jumlahDislike}',
                                style: const TextStyle(color: Colors.red),
                              ),
                              const SizedBox(width: 10),

                              IconButton(
                                icon:
                                    const Icon(Icons.share, color: Colors.blue),
                                onPressed: () {},
                              ),
                              const SizedBox(width: 10),

                              // Tombol Report
                              IconButton(
                                icon:
                                    const Icon(Icons.report, color: Colors.red),
                                onPressed: () {},
                              ),
                            ],
                          ),

                          // Tag berita
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 8.0,
                            children: widget.berita.tags.map((tag) {
                              return ActionChip(
                                onPressed: () {},
                                label: Text(
                                  tag,
                                  style:
                                      const TextStyle(color: AppColors.primary),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  side: const BorderSide(color: Colors.grey),
                                ),
                                backgroundColor: AppColors.background,
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    const Divider(color: Colors.grey, thickness: 0.5),
                  ],
                ),
              ]),
            ),

            // Berita Terkait
            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Berita Terkait',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 150,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: beritaList.length,
                          itemBuilder: (context, index) {
                            return ChangeNotifierProvider.value(
                              value: beritaList[index],
                              child: BeritaTerkaitItem(),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(color: Colors.grey, thickness: 0.5),
              ]),
            ),

            // Berita Lainnya
            SliverPadding(
              padding: const EdgeInsets.all(10),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const Text(
                    'Berita Lainnya',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                ]),
              ),
            ),

            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return ChangeNotifierProvider.value(
                    value: beritaList[index],
                    child: BeritaPopulerItem(),
                  );
                },
                childCount: beritaList.length,
              ),
            ),
          ],
        ),
      ),

      // FAB untuk membuka komentar
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: AppColors.primary,
        onPressed: () {
          showKomentarScreen(context);
        },
        child: const Icon(Icons.comment, color: Colors.white),
      ),
    );
  }
}

// Fungsi untuk menampilkan komentar
void showKomentarScreen(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return const KomentarScreen();
    },
  );
}
