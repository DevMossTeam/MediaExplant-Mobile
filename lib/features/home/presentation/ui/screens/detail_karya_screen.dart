// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:mediaexplant/features/home/models/karya/detail_karya.dart';
import 'package:mediaexplant/features/home/presentation/logic/viewmodel/karya/karya_detail_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/logic/viewmodel/karya/karya_terkait_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/ui/screens/karya_selengkapnya.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita/shimmer_detail_berita_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/karya/puisi_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/title_header_widget.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:mediaexplant/core/constants/app_colors.dart';
import 'package:mediaexplant/core/utils/userID.dart';
import 'package:mediaexplant/features/bookmark/models/bookmark.dart';
import 'package:mediaexplant/features/bookmark/provider/bookmark_provider.dart';
import 'package:mediaexplant/features/comments/presentation/logic/komentar_viewmodel.dart';
import 'package:mediaexplant/features/comments/presentation/ui/screens/komentar_screen.dart';
import 'package:mediaexplant/features/reaksi/models/reaksi.dart';
import 'package:mediaexplant/features/reaksi/provider/Reaksi_provider.dart';
import 'package:mediaexplant/features/report/report_bottom_sheet.dart';

class DetailKaryaScreen extends StatefulWidget {
  final String idKarya;
  final String kategori;

  const DetailKaryaScreen({
    Key? key,
    required this.idKarya,
    required this.kategori,
  }) : super(key: key);

  @override
  State<DetailKaryaScreen> createState() => _DetailKaryaScreenState();
}

String cleanDeskripsi(String html) {
  final document = html_parser.parse(html);
  return document.body?.text.trim() ?? '';
}

class _DetailKaryaScreenState extends State<DetailKaryaScreen> {
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInit) {
      final karyaDetailVM =
          Provider.of<KaryaDetailViewmodel>(context, listen: false);

      karyaDetailVM.refresh(userLogin, widget.idKarya);

      final karyaTerkaitVM =
          Provider.of<KaryaTerkaitViewmodel>(context, listen: false);
      karyaTerkaitVM.refresh(
        userLogin,
        widget.idKarya,
      );

      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookmarkProvider =
        Provider.of<BookmarkProvider>(context, listen: false);
    final reaksiProvider = Provider.of<ReaksiProvider>(context, listen: false);

    final karyaTerkaitList =
        Provider.of<KaryaTerkaitViewmodel>(context).allKarya;

    // Ambil data Detailkarya dari karyaDetailViewmodel
    final karyaDetailVM = Provider.of<KaryaDetailViewmodel>(context);
    final karya = karyaDetailVM.detailKarya;

    // Jika karya belum ada (data masih loading), tampilkan loading spinner
    if (karya == null) {
      return const Scaffold(
        body: Center(
          child: ShimmerDetailBeritaItem(),
        ),
      );
    }
    return ChangeNotifierProvider.value(
      value: karya,
      child: Scaffold(
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
                  child: Consumer<DetailKarya>(builder: (context, karya, _) {
                    return IconButton(
                      onPressed: () async {
                        if (userLogin == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Silakan login terlebih dahulu untuk menyimpan bookmark.'),
                            ),
                          );
                          Navigator.pushNamed(context, '/login');
                          return;
                        }
                        await bookmarkProvider.toggleBookmark(
                          context,
                          Bookmark(
                            userId: userLogin,
                            itemId: karya.idKarya,
                            bookmarkType: "Karya",
                          ),
                        );

                        karya.statusBookmark();
                      },
                      icon: Icon(
                        karya.isBookmark
                            ? Icons.bookmark
                            : Icons.bookmark_outline,
                        color: Colors.white,
                      ),
                    );
                  }),
                ),
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
                      showModalBottomSheet(
                        backgroundColor: AppColors.background,
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20))),
                        builder: (context) => ReportBottomSheet(
                          itemId: karya.idKarya,
                          pesanType: "Karya",
                        ),
                      );
                    },
                    icon: SvgPicture.asset(
                      'assets/images/ic_report.svg',
                      width: 24,
                      height: 24,
                      fit: BoxFit.contain,
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
                            'Diupload oleh: ${karya.penulis} ',
                            style: const TextStyle(color: Colors.grey),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Kreator: ${karya.krator}',
                            style: const TextStyle(color: Colors.grey),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Rilis: ${karya.release}',
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
                            cleanDeskripsi(karya.deskripsi),
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
                            // Center(
                            //   child: Text(
                            //     "(Oleh ${karya.penulis})",
                            //     style: const TextStyle(
                            //       fontSize: 16,
                            //       color: Colors.black,
                            //     ),
                            //   ),
                            // ),
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
                              Consumer<DetailKarya>(
                                  builder: (context, karya, _) {
                                return IconButton(
                                  onPressed: () async {
                                    if (userLogin == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
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
                                          itemId: karya.idKarya,
                                          jenisReaksi: "Suka",
                                          reaksiType: "Karya",
                                        ));
                                    karya.statusLike();
                                  },
                                  icon: Icon(
                                    Icons.thumb_up,
                                    color: karya.isLike
                                        ? Colors.blue
                                        : Colors.grey,
                                  ),
                                );
                              }),
                              Consumer<DetailKarya>(
                                  builder: (context, karya, _) {
                                return Text(
                                  '${karya.jumlahLike}',
                                  style: const TextStyle(color: Colors.blue),
                                );
                              }),
                              const SizedBox(width: 10),
                              Consumer<DetailKarya>(
                                  builder: (context, karya, _) {
                                return IconButton(
                                  onPressed: () async {
                                    if (userLogin == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
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
                                          itemId: karya.idKarya,
                                          jenisReaksi: "Tidak Suka",
                                          reaksiType: "Karya",
                                        ));
                                    karya.statusDislike();
                                  },
                                  icon: Icon(
                                    Icons.thumb_down,
                                    color: karya.isDislike
                                        ? Colors.red
                                        : Colors.grey,
                                  ),
                                );
                              }),

                              Consumer<DetailKarya>(
                                  builder: (context, karya, _) {
                                return Text(
                                  '${karya.jumlahDislike}',
                                  style: const TextStyle(color: Colors.red),
                                );
                              }),
                              const SizedBox(width: 10),

                              IconButton(
                                icon:
                                    const Icon(Icons.share, color: Colors.blue),
                                onPressed: () async {
                                  final kategori = karya.kategori
                                      .toLowerCase()
                                      .replaceAll(' ', '-');
                                  final url =
                                      "http://mediaexplant.com/karya/$kategori/read?k=${karya.idKarya}";

                                  await Share.share(
                                      "Baca karya menarik ini di MediaExplant:\n\n${karya.judul}\n$url");
                                },
                              ),
                              const SizedBox(width: 10),
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
            SliverToBoxAdapter(
              child: Padding(
                  padding: const EdgeInsets.only(left: 15, top: 15),
                  child: titleHeader("Karya Terkait", "mungkin anda suka")),
            ),
            // karya terkait
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 5),
                child: SizedBox(
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
                    itemCount: karyaTerkaitList.length,
                    itemBuilder: (context, index) {
                      return ChangeNotifierProvider.value(
                        value: karyaTerkaitList[index],
                        child: PuisiItem(),
                      );
                    },
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      final karyaId = karya.idKarya;
                      final kategoriKarya = karya.kategori;

                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) {
                          final viewModel = KaryaSelengkapnyaViewModel();
                          return ChangeNotifierProvider<
                              KaryaSelengkapnyaViewModel>(
                            create: (_) {
                              // Pastikan parameter lengkap dikirim di awal
                              viewModel.setKategori(KategoriKarya.terkait,
                                  KaryaId: karyaId,
                                  KategoriKarya: kategoriKarya);
                              return viewModel;
                            },
                            child: KaryaSelengkapnya(
                              kategori: KategoriKarya.terkait,
                              KaryaIdTerkait: karyaId,
                              kategoriTerkait: kategoriKarya,
                            ),
                          );
                        }),
                      );
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
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 70),
            ),
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
