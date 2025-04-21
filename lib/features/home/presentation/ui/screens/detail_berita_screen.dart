import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mediaexplant/core/constants/app_colors.dart';
import 'package:mediaexplant/features/bookmark/models/bookmark.dart';
import 'package:mediaexplant/features/bookmark/provider/bookmark_provider.dart';
import 'package:mediaexplant/features/home/data/models/berita.dart';
import 'package:mediaexplant/features/comments/presentation/ui/screens/komentar_screen.dart';
import 'package:mediaexplant/features/home/presentation/logic/berita_terkini_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita_populer_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita_terbaru_item.dart';
import 'package:mediaexplant/features/reaksi/models/reaksi.dart';
import 'package:mediaexplant/features/reaksi/provider/Reaksi_provider.dart';
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
    final beritaProvider = Provider.of<BeritaTerkiniViewmodel>(context);
    final beritaList = beritaProvider.allBerita;
    final bookmarkProvider =
        Provider.of<BookmarkProvider>(context, listen: false);
    final reaksiProvider = Provider.of<ReaksiProvider>(context, listen: false);

    String kontenTanpaGambar =
        removeFirstImageFromKonten(widget.berita.kontenBerita);

    // String removeFirstImageFromKonten(String konten) {
    //   final RegExp regExp = RegExp(r'<img[^>]*src="[^"]*"[^>]*>');
    //   return konten.replaceFirst(regExp, '');
    // }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
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
                  onPressed: () async {
                    bookmarkProvider.toggleBookmark(Bookmark(
                        userId: "4FUD7QhJ0hMLMMlF6VQHjvkXad4L",
                        beritaId: widget.berita.idBerita,
                        bookmarkType: "Berita"));
                    setState(() {
                      widget.berita.isBookmark = !widget.berita.isBookmark;
                    });
                  },
                  icon: (widget.berita.isBookmark)
                      ? const Icon(Icons.bookmark, color: Colors.white)
                      : const Icon(Icons.bookmark_outline, color: Colors.white),
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
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.berita.kategori,
                          style: const TextStyle(
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
                    padding: const EdgeInsets.symmetric(horizontal: 8),
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
                              // lineHeight: LineHeight.number(1.5),
                            ),
                            "p": Style(
                              margin: Margins.symmetric(horizontal: 0),
                            ),
                          },
                        ),

                        const SizedBox(height: 20),

                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 7),
                          child: Text(
                            "Berikan Tanggapanmu :",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),

                        // Tombol interaksi
                        Row(
                          children: [
                            // Tombol Like
                            IconButton(
                              onPressed: () async {
                                final isCurrentlyLiked = widget.berita.isLike;
                                final isCurrentlyDisliked =
                                    widget.berita.isDislike;

                                await reaksiProvider.toggleReaksi(Reaksi(
                                  userId: "4FUD7QhJ0hMLMMlF6VQHjvkXad4L",
                                  beritaId: widget.berita.idBerita,
                                  jenisReaksi: "Suka",
                                  reaksiType: "Berita",
                                ));

                                setState(() {
                                  if (isCurrentlyLiked) {
                                    // Batal like
                                    widget.berita.isLike = false;
                                    widget.berita.jumlahLike =
                                        (widget.berita.jumlahLike - 1)
                                            .clamp(0, double.infinity)
                                            .toInt();
                                  } else {
                                    // Like baru
                                    widget.berita.isLike = true;
                                    widget.berita.jumlahLike += 1;

                                    // Jika sebelumnya dislike, batalkan
                                    if (isCurrentlyDisliked) {
                                      widget.berita.isDislike = false;
                                      widget.berita.jumlahDislike =
                                          (widget.berita.jumlahDislike - 1)
                                              .clamp(0, double.infinity)
                                              .toInt();
                                    }
                                  }
                                });
                              },
                              icon: Icon(
                                Icons.thumb_up,
                                color: widget.berita.isLike
                                    ? Colors.blue
                                    : Colors.grey,
                              ),
                            ),
                            Text(
                              '${widget.berita.jumlahLike}',
                              style: const TextStyle(color: Colors.blue),
                            ),
                            const SizedBox(width: 10),

                            // Tombol Dislike
                            IconButton(
                              onPressed: () async {
                                final isCurrentlyLiked = widget.berita.isLike;
                                final isCurrentlyDisliked =
                                    widget.berita.isDislike;

                                await reaksiProvider.toggleReaksi(Reaksi(
                                  userId: "4FUD7QhJ0hMLMMlF6VQHjvkXad4L",
                                  beritaId: widget.berita.idBerita,
                                  jenisReaksi: "Tidak Suka",
                                  reaksiType: "Berita",
                                ));

                                setState(() {
                                  if (isCurrentlyDisliked) {
                                    // Batal dislike
                                    widget.berita.isDislike = false;
                                    widget.berita.jumlahDislike =
                                        (widget.berita.jumlahDislike - 1)
                                            .clamp(0, double.infinity)
                                            .toInt();
                                  } else {
                                    // Dislike baru
                                    widget.berita.isDislike = true;
                                    widget.berita.jumlahDislike += 1;

                                    // Jika sebelumnya like, batalkan
                                    if (isCurrentlyLiked) {
                                      widget.berita.isLike = false;
                                      widget.berita.jumlahLike =
                                          (widget.berita.jumlahLike - 1)
                                              .clamp(0, double.infinity)
                                              .toInt();
                                    }
                                  }
                                });
                              },
                              icon: Icon(
                                Icons.thumb_down,
                                color: widget.berita.isDislike
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),
                            Text(
                              '${widget.berita.jumlahDislike}',
                              style: const TextStyle(color: Colors.red),
                            ),
                            const SizedBox(width: 10),

                            IconButton(
                              icon: const Icon(Icons.share, color: Colors.blue),
                              onPressed: () {},
                            ),
                            const SizedBox(width: 10),

                            // Tombol Report
                            IconButton(
                              icon: const Icon(Icons.report, color: Colors.red),
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

          // // Berita Terkait
          // SliverList(
          //   delegate: SliverChildListDelegate([
          //     Padding(
          //       padding: const EdgeInsets.all(15),
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           const Text(
          //             'Berita Terkait',
          //             style:
          //                 TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          //           ),
          //           const SizedBox(height: 10),
          //           SizedBox(
          //             height: 150,
          //             child: ListView.builder(
          //               scrollDirection: Axis.horizontal,
          //               itemCount: beritaList.length,
          //               itemBuilder: (context, index) {
          //                 return ChangeNotifierProvider.value(
          //                   value: beritaList[index],
          //                   child: BeritaTerkaitItem(),
          //                 );
          //               },
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //     const Divider(color: Colors.grey, thickness: 0.5),
          //   ]),
          // ),

          // rekomendasi Lainnya
          // SliverPadding(
          //   padding: const EdgeInsets.all(15),
          //   sliver: SliverList(
          //     delegate: SliverChildListDelegate([
          //       const Text(
          //         'Rekomendasi Lainnya',
          //         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          //       ),
          //     ]),
          //   ),
          // ),

          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(left: 15, top: 15, bottom: 10),
              child: Row(
                children: [
                  Text(
                    "Rekomandasi Lainnya",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Mungkin anda sukai",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            sliver: SliverList(
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
          ),

          // berita terbaru
          SliverPadding(
            padding: const EdgeInsets.only(top: 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  color: Colors.grey.withAlpha(50),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 10, top: 20, bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Text(
                              "Terbaru",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Teratas untuk anda",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 150,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: beritaList.length,
                            itemBuilder: (context, index) {
                              return ChangeNotifierProvider.value(
                                value: beritaList[index],
                                child: BeritaTerbaruItem(),
                              );
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                // aksi saat tombol ditekan
                                print("Tombol ditekan");
                              },
                              child: const Text(
                                "Selengkapnya >>",
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // const Divider(color: Colors.grey, thickness: 0.5),
              ]),
            ),
          ),
        ],
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
