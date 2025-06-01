// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:mediaexplant/features/home/models/produk/detail_produk.dart';
import 'package:mediaexplant/features/home/presentation/logic/viewmodel/produk/produk_detail_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/logic/viewmodel/produk/produk_terkait_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/produk/produk_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/title_header_widget.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mediaexplant/core/constants/app_colors.dart';
import 'package:mediaexplant/core/utils/userID.dart';
import 'package:mediaexplant/features/bookmark/models/bookmark.dart';
import 'package:mediaexplant/features/bookmark/provider/bookmark_provider.dart';
import 'package:mediaexplant/features/reaksi/models/reaksi.dart';
import 'package:mediaexplant/features/reaksi/provider/Reaksi_provider.dart';

class DetailProdukScreen extends StatefulWidget {
  final String idProduk;
  final String kategori;

  const DetailProdukScreen({
    Key? key,
    required this.idProduk,
    required this.kategori,
  }) : super(key: key);

  @override
  State<DetailProdukScreen> createState() => _DetailProdukScreenState();
}

String cleanDeskripsi(String html) {
  final document = html_parser.parse(html);
  return document.body?.text.trim() ?? '';
}

class _DetailProdukScreenState extends State<DetailProdukScreen> {
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInit) {
      final produkDetailVM =
          Provider.of<ProdukDetailViewmodel>(context, listen: false);

      produkDetailVM.refresh(userLogin, widget.idProduk);

      final produkTerkaitVM =
          Provider.of<ProdukTerkaitViewmodel>(context, listen: false);
      produkTerkaitVM.refresh(
        userLogin,
        widget.idProduk,
      );

      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookmarkProvider =
        Provider.of<BookmarkProvider>(context, listen: false);
    final reaksiProvider = Provider.of<ReaksiProvider>(context, listen: false);

    final produkTerkaitList =
        Provider.of<ProdukTerkaitViewmodel>(context).allProduk;

    // Ambil data DetailProduk dari ProdukDetailViewmodel
    final produkDetailVM = Provider.of<ProdukDetailViewmodel>(context);
    final produk = produkDetailVM.detailProduk;

    // Jika produk belum ada (data masih loading), tampilkan loading spinner
    if (produk == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return ChangeNotifierProvider.value(
      value: produk,
      child: Scaffold(
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
                          child: produk.cover.isNotEmpty
                              ? Image.memory(
                                  produk.gambar(),
                                  fit: BoxFit.cover,
                                )
                              : const Center(
                                  child: CircularProgressIndicator()),
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
                      Consumer<DetailProduk>(builder: (context, produk, _) {
                        return IconButton(
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
                            await reaksiProvider.toggleReaksi(
                                context,
                                Reaksi(
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
                        );
                      }),
                      Consumer<DetailProduk>(builder: (context, produk, _) {
                        return Text(
                          '${produk.jumlahLike}',
                          style: const TextStyle(color: Colors.blue),
                        );
                      }),
                      const SizedBox(width: 10),
                      Consumer<DetailProduk>(builder: (context, produk, _) {
                        return IconButton(
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
                            await reaksiProvider.toggleReaksi(
                                context,
                                Reaksi(
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
                        );
                      }),

                      Consumer<DetailProduk>(builder: (context, produk, _) {
                        return Text(
                          '${produk.jumlahDislike}',
                          style: const TextStyle(color: Colors.red),
                        );
                      }),
                      const SizedBox(width: 10),

                      IconButton(
                        icon: const Icon(Icons.share, color: Colors.blue),
                        onPressed: () async {
                          final kategori = produk.kategori
                              .toLowerCase()
                              .replaceAll(' ', '-');
                          final url =
                              "http://mediaexplant.com/produk/$kategori/browse?f=${produk.idproduk}";

                          await Share.share(
                              "Baca karya menarik ini di MediaExplant:\n\n${produk.judul}\n$url");
                        },
                      ),
                      Container(
                        height: 25,
                        width: 2,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        color: Colors.grey,
                      ),
                      Consumer<DetailProduk>(builder: (context, produk, _) {
                        return IconButton(
                          onPressed: () async {
                            await bookmarkProvider.toggleBookmark(
                              context,
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
                                ? Icons.bookmark_add
                                : Icons.bookmark_add_outlined,
                            size: 30,
                            color: Colors.grey,
                          ),
                        );
                      }),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Expanded(
                  //       child: ElevatedButton.icon(
                  //         onPressed: () async {
                  //           await produkVW.downloadProduk(produk.idproduk);
                  //         },
                  //         icon: const Icon(Icons.download),
                  //         label: const Text('Download'),
                  //         style: ElevatedButton.styleFrom(
                  //           shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(10),
                  //           ),
                  //           backgroundColor: AppColors.button_download,
                  //           foregroundColor: Colors.white,
                  //         ),
                  //       ),
                  //     ),
                  //     const SizedBox(
                  //       width: 10,
                  //     ),
                  //     Expanded(
                  //       child: ElevatedButton.icon(
                  //         onPressed: () async {
                  //           // pratinjau
                  //         },
                  //         icon: const Icon(Icons.remove_red_eye),
                  //         label: const Text('Pratinjau'),
                  //         style: ElevatedButton.styleFrom(
                  //           shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(10),
                  //           ),
                  //           backgroundColor: Colors.black,
                  //           foregroundColor: Colors.white,
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(
                  //   height: 20,
                  // ),
                  Text(
                    "Tentang ${produk.kategori} ini",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () async {
                      final kategori =
                          produk.kategori.toLowerCase().replaceAll(' ', '-');
                      final url =
                          "http://mediaexplant.com/produk/$kategori/pdf-preview/${produk.idproduk}#page=1";
                      final uri = Uri.parse(url);

                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri,
                            mode: LaunchMode.externalApplication);
                      } else {
                        debugPrint("Tidak dapat membuka URL: $url");
                      }
                    },
                    child: const Text(
                      "🔗 Kunjungi halaman produk ini",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  Text(
                    cleanDeskripsi(produk.deskripsi),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20,),

                  titleHeader("Produk Terkait", "mungkin anda suka"),
                  const SizedBox(height: 10,),
                  // produk terkait
                  SizedBox(
                    width: double.infinity,
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 5,
                        childAspectRatio: 0.5,
                      ),
                      itemCount: produkTerkaitList.length,
                      itemBuilder: (context, index) {
                        return ChangeNotifierProvider.value(
                          value: produkTerkaitList[index],
                          child: ProdukItem(),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
