import 'package:flutter/material.dart';
import 'package:mediaexplant/core/constants/app_colors.dart';
import 'package:mediaexplant/features/bookmark/models/bookmark.dart';
import 'package:mediaexplant/features/bookmark/provider/bookmark_provider.dart';
import 'package:mediaexplant/features/comments/presentation/ui/screens/komentar_screen.dart';
import 'package:mediaexplant/features/home/models/produk/produk.dart';
import 'package:mediaexplant/features/home/presentation/logic/produk/produk_view_model.dart';
import 'package:mediaexplant/features/reaksi/models/reaksi.dart';
import 'package:mediaexplant/features/reaksi/provider/Reaksi_provider.dart';
import 'package:provider/provider.dart';

class DetailProdukScreen extends StatefulWidget {
  const DetailProdukScreen({super.key});

  @override
  State<DetailProdukScreen> createState() => _DetailProdukScreenState();
}

class _DetailProdukScreenState extends State<DetailProdukScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bookmarkProvider =
        Provider.of<BookmarkProvider>(context, listen: false);
    final reaksiProvider = Provider.of<ReaksiProvider>(context, listen: false);
    // final berita = Provider.of<Berita>(context);

    final majalah = Provider.of<Produk>(context);
    final majalahVW = Provider.of<ProdukViewModel>(context, listen: false);

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
                    majalah.thumbnail == null
                        ? const Center(child: CircularProgressIndicator())
                        : Image.memory(majalah.thumbnail!, fit: BoxFit.cover),
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
                    await bookmarkProvider.toggleBookmark(
                      Bookmark(
                        userId: "4FUD7QhJ0hMLMMlF6VQHjvkXad4L",
                        itemId: majalah.idproduk,
                        bookmarkType: "Produk",
                      ),
                    );

                    majalah.statusBookmark();
                  },
                  icon: Icon(
                    majalah.isBookmark
                        ? Icons.bookmark
                        : Icons.bookmark_outline,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          // SliverToBoxAdapter(
          //   child: Row(
          //     children: [
          //       ClipRRect(
          //         borderRadius: BorderRadius.circular(5),
          //         child: AspectRatio(aspectRatio: 3 / 4),
          //       ),
          //     ],
          //   ),
          // ),

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
                          majalah.kategori,
                          style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          majalah.judul,
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
                          'Oleh: ${majalah.penulis}  |  ${majalah.release_date}',
                          style: const TextStyle(color: Colors.grey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const Divider(color: Colors.grey, thickness: 0.5),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          elevation: 5,
                          margin: const EdgeInsets.all(8),
                          clipBehavior: Clip.antiAlias,
                          child: SizedBox(
                            height: 230,
                            width: 170,
                            child: majalah.thumbnail == null
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : Image.memory(majalah.thumbnail!,
                                    fit: BoxFit.cover),
                          ),
                        ),
                        Column(
                          children: [
                            SizedBox(
                              width: 180,
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  await majalahVW
                                      .downloadProduk(majalah.idproduk);
                                },
                                icon: const Icon(Icons.download),
                                label: const Text('Download'),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  backgroundColor: AppColors.button_download,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 180,
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  // akan ngebaca pdf
                                  // Misalnya idProduk diambil dari data produk
                                  // majalahVW.previewProduk(
                                  //     majalah.idproduk, context);
                                },
                                icon: const Icon(Icons.remove_red_eye),
                                label: const Text('Pratinjau'),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                                await reaksiProvider.toggleReaksi(Reaksi(
                                  userId: "4FUD7QhJ0hMLMMlF6VQHjvkXad4L",
                                  itemId: majalah.idproduk,
                                  jenisReaksi: "Suka",
                                  reaksiType: "Produk",
                                ));
                                majalah.statusLike();
                              },
                              icon: Icon(
                                Icons.thumb_up,
                                color:
                                    majalah.isLike ? Colors.blue : Colors.grey,
                              ),
                            ),
                            Text(
                              '${majalah.jumlahLike}',
                              style: const TextStyle(color: Colors.blue),
                            ),
                            const SizedBox(width: 10),
                            IconButton(
                              onPressed: () async {
                                await reaksiProvider.toggleReaksi(Reaksi(
                                  userId: "4FUD7QhJ0hMLMMlF6VQHjvkXad4L",
                                  itemId: majalah.idproduk,
                                  jenisReaksi: "Tidak Suka",
                                  reaksiType: "Produk",
                                ));
                                majalah.statusDislike();
                              },
                              icon: Icon(
                                Icons.thumb_down,
                                color: majalah.isDislike
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),

                            Text(
                              '${majalah.jumlahDislike}',
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
                      ],
                    ),
                  ),
                  const Divider(color: Colors.grey, thickness: 0.5),
                ],
              ),
            ]),
          ),

          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(left: 15, top: 15, bottom: 10),
              child: Row(
                children: [
                  Text(
                    "Produk Terkait",
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
