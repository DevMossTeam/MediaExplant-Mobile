import 'package:flutter/material.dart';
import 'package:mediaexplant/core/constants/app_colors.dart';
import 'package:mediaexplant/features/bookmark/models/bookmark.dart';
import 'package:mediaexplant/features/bookmark/provider/bookmark_provider.dart';
import 'package:mediaexplant/features/comments/presentation/logic/komentar_viewmodel.dart';
import 'package:mediaexplant/features/comments/presentation/ui/screens/komentar_screen.dart';
import 'package:mediaexplant/features/home/models/karya/karya.dart';
import 'package:mediaexplant/features/home/presentation/ui/screens/home_screen.dart';
import 'package:mediaexplant/features/reaksi/models/reaksi.dart';
import 'package:mediaexplant/features/reaksi/provider/Reaksi_provider.dart';
import 'package:provider/provider.dart';

class DetailKaryaScreen extends StatefulWidget {
  const DetailKaryaScreen({super.key});

  @override
  State<DetailKaryaScreen> createState() => _DetailKaryaScreenState();
}

class _DetailKaryaScreenState extends State<DetailKaryaScreen> {
  @override
  void initState() {
    super.initState();

    // provider
    // view model

    ;
  }

  @override
  Widget build(BuildContext context) {
    final bookmarkProvider =
        Provider.of<BookmarkProvider>(context, listen: false);
    final reaksiProvider = Provider.of<ReaksiProvider>(context, listen: false);
    final karya = Provider.of<Karya>(context);
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
                    karya.media.isNotEmpty
                        ? Image.memory(
                            karya.gambar(),
                            fit: BoxFit.cover,
                          )
                        : const Center(child: CircularProgressIndicator()),
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
                        userId: userLogin,
                        itemId: karya.idKarya,
                        bookmarkType: "Karya",
                      ),
                    );

                    karya.statusBookmark();
                  },
                  icon: Icon(
                    karya.isBookmark ? Icons.bookmark : Icons.bookmark_outline,
                    color: Colors.white,
                  ),
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
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/app_logo.png',
                              height: 30,
                              width: 30,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              karya.kategoriFormatted,
                              style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          karya.judul,
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
                          'Oleh: ${karya.penulis}  |  ${karya.release}',
                          style: const TextStyle(color: Colors.grey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const Divider(color: Colors.grey, thickness: 0.5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          karya.deskripsi,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),

                        if (karya.kategori != 'desain_grafis' &&
                            karya.kategori != 'fotografi') ...[
                          Center(
                            child: Text(
                              karya.judul,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              "(Oleh ${karya.penulis})",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],

                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          karya.kontenKarya,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
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
                                  itemId: karya.idKarya,
                                  jenisReaksi: "Suka",
                                  reaksiType: "Karya",
                                ));
                                karya.statusLike();
                              },
                              icon: Icon(
                                Icons.thumb_up,
                                color: karya.isLike ? Colors.blue : Colors.grey,
                              ),
                            ),
                            Text(
                              '${karya.jumlahLike}',
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
                                  itemId: karya.idKarya,
                                  jenisReaksi: "Tidak Suka",
                                  reaksiType: "Karya",
                                ));
                                karya.statusDislike();
                              },
                              icon: Icon(
                                Icons.thumb_down,
                                color:
                                    karya.isDislike ? Colors.red : Colors.grey,
                              ),
                            ),

                            Text(
                              '${karya.jumlahDislike}',
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

          // const SliverToBoxAdapter(
          //   child: Padding(
          //     padding: EdgeInsets.only(left: 15, top: 15, bottom: 10),
          //     child: Row(
          //       children: [
          //         Text(
          //           "Berita Terkait",
          //           style: TextStyle(
          //             fontSize: 16,
          //             fontWeight: FontWeight.bold,
          //             color: Colors.black,
          //           ),
          //         ),
          //         SizedBox(
          //           width: 10,
          //         ),
          //         Text(
          //           "Mungkin anda sukai",
          //           style: TextStyle(
          //             fontSize: 12,
          //             color: Colors.grey,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          // // // BERITA terkait
          // // SliverPadding(
          // //   padding: const EdgeInsets.symmetric(horizontal: 5),
          // //   sliver: SliverList(
          // //     delegate: SliverChildBuilderDelegate(
          // //       (context, index) {
          // //         return ChangeNotifierProvider.value(
          // //           value: beritaTerkaitList[index],
          // //           child: BeritaPopulerItem(),
          // //         );
          // //       },
          // //       childCount: beritaTerkaitList.length,
          // //     ),
          // //   ),
          // // ),
          // // SliverToBoxAdapter(
          // //   child: Row(
          // //     mainAxisAlignment: MainAxisAlignment.end,
          // //     children: [
          // //       TextButton(
          // //         onPressed: () {
          // //           // aksi saat tombol ditekan
          // //         },
          // //         child: const Text(
          // //           "Selengkapnya >>",
          // //           style: TextStyle(
          // //             color: AppColors.primary,
          // //             fontSize: 14,
          // //           ),
          // //         ),
          // //       ),
          // //     ],
          // //   ),
          // // ),

          // // // berita terbaru
          // // SliverPadding(
          // //   padding: const EdgeInsets.only(top: 20),
          // //   sliver: SliverList(
          // //     delegate: SliverChildListDelegate([
          // //       Container(
          // //         color: Colors.grey.withAlpha(50),
          // //         child: Padding(
          // //           padding:
          // //               const EdgeInsets.only(left: 10, top: 20, bottom: 20),
          // //           child: Column(
          // //             crossAxisAlignment: CrossAxisAlignment.start,
          // //             children: [
          // //               const Row(
          // //                 children: [
          // //                   Text(
          // //                     "Terbaru",
          // //                     style: TextStyle(
          // //                       fontSize: 16,
          // //                       fontWeight: FontWeight.bold,
          // //                       color: Colors.black,
          // //                     ),
          // //                   ),
          // //                   SizedBox(
          // //                     width: 10,
          // //                   ),
          // //                   Text(
          // //                     "Teratas untuk anda",
          // //                     style: TextStyle(
          // //                       fontSize: 12,
          // //                       color: Colors.grey,
          // //                     ),
          // //                   ),
          // //                 ],
          // //               ),
          // //               const SizedBox(height: 10),
          // //               // BERITA TERBARU
          // //               // SizedBox(
          // //               //   height: 180,
          // //               //   child: ListView.builder(
          // //               //     scrollDirection: Axis.horizontal,
          // //               //     itemCount: 10,
          // //               //     itemBuilder: (context, index) {
          // //               //       return ChangeNotifierProvider.value(
          // //               //         value: beritaTerbaruList[index],
          // //               //         child: BeritaTerbaruItem(),
          // //               //       );
          // //               //     },
          // //               //   ),
          // //               // ),
          // //               Row(
          // //                 mainAxisAlignment: MainAxisAlignment.end,
          // //                 children: [
          // //                   TextButton(
          // //                     onPressed: () {
          // //                       // aksi saat tombol ditekan
          // //                     },
          // //                     child: const Text(
          // //                       "Selengkapnya >>",
          // //                       style: TextStyle(
          // //                         color: AppColors.primary,
          // //                         fontSize: 14,
          // //                       ),
          // //                     ),
          // //                   ),
          // //                 ],
          // //               ),
          // //               const SizedBox(
          // //                 height: 50,
          // //               ),
          // //             ],
          // //           ),
          // //         ),
          // //       ),
          // //       // const Divider(color: Colors.grey, thickness: 0.5),
          // //     ]),
          // //   ),
          // // ),
        ],
      ),

      // FAB untuk membuka komentar
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: AppColors.primary,
        onPressed: () {
          if (userLogin == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Silakan login terlebih dahulu untuk memberi komentar.',
                ),
              ),
            );
            Navigator.pushNamed(context, '/login');
            return;
          }

          showKomentarBottomSheet(
            context,
            'Karya',
            karya.idKarya,
            userLogin,
          );
        },
        child: const Icon(Icons.comment, color: Colors.white),
      ),
    );
  }
}

void showKomentarBottomSheet(
    BuildContext context, String komentarType, String itemId, String? userId) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => ChangeNotifierProvider(
      create: (_) => KomentarViewmodel()
        ..fetchKomentar(komentarType: komentarType, itemId: itemId),
      child: KomentarBottomSheet(
        komentarType: komentarType,
        itemId: itemId,
        userId: userId,
      ),
    ),
  );
}
