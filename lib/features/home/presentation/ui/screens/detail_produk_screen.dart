import 'package:flutter/material.dart';
import 'package:mediaexplant/core/constants/app_colors.dart';
import 'package:mediaexplant/core/utils/userID.dart';
import 'package:mediaexplant/features/bookmark/models/bookmark.dart';
import 'package:mediaexplant/features/bookmark/provider/bookmark_provider.dart';
import 'package:mediaexplant/features/home/models/produk/produk.dart';
import 'package:mediaexplant/features/home/presentation/logic/viewmodel/produk/produk_view_model.dart';
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
  Widget build(BuildContext context) {
    final bookmarkProvider =
        Provider.of<BookmarkProvider>(context, listen: false);
    final reaksiProvider = Provider.of<ReaksiProvider>(context, listen: false);
    // final berita = Provider.of<Berita>(context);

    final produk = Provider.of<Produk>(context);
    final produkVW = Provider.of<ProdukViewModel>(context, listen: false);

    return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
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
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      elevation: 5,
                      margin: const EdgeInsets.only(right: 12),
                      clipBehavior: Clip.antiAlias,
                      child: SizedBox(
                        height: 190,
                        width: 120,
                        child: produk.thumbnail == null
                            ? const Center(child: CircularProgressIndicator())
                            : Image.memory(produk.thumbnail!,
                                fit: BoxFit.cover),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            produk.judul,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/app_logo.png',
                                height: 20,
                                width: 20,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                produk.kategori,
                                style: const TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Oleh: ${produk.penulis}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Rilis: ${produk.release_date}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    // Tombol Like
                    IconButton(
                      onPressed: () async {
                        if (userLogin == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Silakan login terlebih dahulu untuk menyimpan reaksi.'),
                            ),
                          );
                          Navigator.pushNamed(context, '/login');
                          return;
                        }
                        await reaksiProvider.toggleReaksi(Reaksi(
                          userId: userLogin,
                          itemId: produk.idproduk,
                          jenisReaksi: "Suka",
                          reaksiType: "Produk",
                        ));
                        produk.statusLike();
                      },
                      icon: Icon(
                        Icons.thumb_up,
                        color: produk.isLike ? Colors.blue : Colors.grey,
                      ),
                    ),
                    Text(
                      '${produk.jumlahLike}',
                      style: const TextStyle(color: Colors.blue),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      onPressed: () async {
                        if (userLogin == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Silakan login terlebih dahulu untuk menyimpan reaksi.'),
                            ),
                          );
                          Navigator.pushNamed(context, '/login');
                          return;
                        }
                        await reaksiProvider.toggleReaksi(Reaksi(
                          userId: userLogin,
                          itemId: produk.idproduk,
                          jenisReaksi: "Tidak Suka",
                          reaksiType: "Produk",
                        ));
                        produk.statusDislike();
                      },
                      icon: Icon(
                        Icons.thumb_down,
                        color: produk.isDislike ? Colors.red : Colors.grey,
                      ),
                    ),

                    Text(
                      '${produk.jumlahDislike}',
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(width: 10),

                    IconButton(
                      icon: const Icon(Icons.share, color: Colors.blue),
                      onPressed: () {},
                    ),
                    Container(
                      height: 25,
                      width: 2,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      color: Colors.grey,
                    ),
                    IconButton(
                      onPressed: () async {
                        await bookmarkProvider.toggleBookmark(
                          Bookmark(
                            userId: userLogin,
                            itemId: produk.idproduk,
                            bookmarkType: "Produk",
                          ),
                        );
                        produk.statusBookmark();
                      },
                      icon: Icon(
                        produk.isBookmark
                            ? Icons.bookmark_add_outlined
                            : Icons.bookmark_add,
                        size: 30,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          await produkVW.downloadProduk(produk.idproduk);
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
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          // pratinjau
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
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Tentang ${produk.kategori} ini",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  produk.deskripsi,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ));
  }
}
