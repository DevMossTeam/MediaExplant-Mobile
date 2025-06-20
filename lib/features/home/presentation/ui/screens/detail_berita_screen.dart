// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mediaexplant/features/home/models/berita/detail_berita.dart';
import 'package:mediaexplant/features/home/presentation/logic/viewmodel/berita/berita_topik_lainnya_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita/shimmer_detail_berita_item.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mediaexplant/core/constants/app_colors.dart';
import 'package:mediaexplant/core/utils/userID.dart';
import 'package:mediaexplant/features/bookmark/models/bookmark.dart';
import 'package:mediaexplant/features/bookmark/provider/bookmark_provider.dart';
import 'package:mediaexplant/features/comments/presentation/logic/komentar_viewmodel.dart';
import 'package:mediaexplant/features/comments/presentation/ui/screens/komentar_screen.dart';
import 'package:mediaexplant/features/home/presentation/logic/viewmodel/berita/berita_detail_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/logic/viewmodel/berita/berita_terkait_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/ui/screens/berita_selengkapnya.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita/berita_populer_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita/berita_terbaru_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/title_header_widget.dart';
import 'package:mediaexplant/features/reaksi/models/reaksi.dart';
import 'package:mediaexplant/features/reaksi/provider/Reaksi_provider.dart';
import 'package:mediaexplant/features/report/report_bottom_sheet.dart';

class DetailBeritaScreen extends StatefulWidget {
  final String idBerita;
  final String kategori;
  const DetailBeritaScreen({
    Key? key,
    required this.idBerita,
    required this.kategori,
  }) : super(key: key);

  @override
  State<DetailBeritaScreen> createState() => _DetailBeritaScreenState();
}

class _DetailBeritaScreenState extends State<DetailBeritaScreen> {
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInit) {
      final beritaDetailVM =
          Provider.of<BeritaDetailViewmodel>(context, listen: false);

      beritaDetailVM.refresh(userLogin, widget.idBerita);

      final beritaTerkaitViewmodel =
          Provider.of<BeritaTerkaitViewmodel>(context, listen: false);
      beritaTerkaitViewmodel.refresh(
        userLogin,
        widget.kategori,
        widget.idBerita,
      );

      final beritaTopikLainnyaViewmodel =
          Provider.of<BeritaTopikLainnyaViewmodel>(context, listen: false);
      beritaTopikLainnyaViewmodel.refresh(
          userLogin, widget.kategori, widget.idBerita);

      _isInit = false; // Pastikan hanya dipanggil sekali per instance
    }
  }

  String removeFirstImageFromKonten(String konten) {
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
    final beritaDetailVM = Provider.of<BeritaDetailViewmodel>(context);
    final berita = beritaDetailVM.berita;

    final beritaTerkaitList =
        Provider.of<BeritaTerkaitViewmodel>(context).allBerita;

    final beritaTopikLainnyaList =
        Provider.of<BeritaTopikLainnyaViewmodel>(context).allBerita;

    final bookmarkProvider =
        Provider.of<BookmarkProvider>(context, listen: false);
    final reaksiProvider = Provider.of<ReaksiProvider>(context, listen: false);

    if (berita == null) {
      return const Scaffold(
        body: Center(
          child: ShimmerDetailBeritaItem(),
        ),
      );
    }

    String kontenTanpaGambar = removeFirstImageFromKonten(berita.kontenBerita);
    return ChangeNotifierProvider.value(
      value: berita,
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
                      CachedNetworkImage(
                        imageUrl: berita.firstImageFromKonten ??
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
                  child: Consumer<DetailBerita>(
                    builder: ((context, berita, _) {
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
                              itemId: berita.idBerita,
                              bookmarkType: "Berita",
                            ),
                          );

                          berita.statusBookmark();
                        },
                        icon: Icon(
                          berita.isBookmark
                              ? Icons.bookmark
                              : Icons.bookmark_outline,
                          color: Colors.white,
                        ),
                      );
                    }),
                  ),
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
                          itemId: berita.idBerita,
                          pesanType: "Berita",
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
                                berita.kategori,
                                style: const TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            berita.judul,
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
                            'Diupload oleh: ${berita.penulis}  |  ${berita.tanggalDibuat}',
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
                              ),
                              "p": Style(
                                margin: Margins.symmetric(horizontal: 0),
                              ),
                            },
                            onLinkTap: (
                              url,
                              _,
                              __,
                            ) {
                              if (url != null) {
                                launchUrl(Uri.parse(url),
                                    mode: LaunchMode.externalApplication);
                              }
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
                              Consumer<DetailBerita>(
                                  builder: (context, berita, _) {
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
                                          itemId: berita.idBerita,
                                          jenisReaksi: "Suka",
                                          reaksiType: "Berita",
                                        ));
                                    berita.statusLike();
                                  },
                                  icon: Icon(
                                    Icons.thumb_up,
                                    color: berita.isLike
                                        ? Colors.blue
                                        : Colors.grey,
                                  ),
                                );
                              }),
                              Consumer<DetailBerita>(
                                  builder: (context, berita, _) {
                                return Text(
                                  '${berita.jumlahLike}',
                                  style: const TextStyle(color: Colors.blue),
                                );
                              }),
                              const SizedBox(width: 10),
                              Consumer<DetailBerita>(
                                  builder: (context, berita, _) {
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
                                          itemId: berita.idBerita,
                                          jenisReaksi: "Tidak Suka",
                                          reaksiType: "Berita",
                                        ));
                                    berita.statusDislike();
                                  },
                                  icon: Icon(
                                    Icons.thumb_down,
                                    color: berita.isDislike
                                        ? Colors.red
                                        : Colors.grey,
                                  ),
                                );
                              }),

                              Consumer<DetailBerita>(
                                  builder: (context, berita, _) {
                                return Text(
                                  '${berita.jumlahDislike}',
                                  style: const TextStyle(color: Colors.red),
                                );
                              }),
                              const SizedBox(width: 10),

                              IconButton(
                                icon:
                                    const Icon(Icons.share, color: Colors.blue),
                                onPressed: () async {
                                  final kategori = berita.kategori
                                      .toLowerCase()
                                      .replaceAll(' ', '-');
                                  final url =
                                      "http://mediaexplant.com/kategori/$kategori/read?a=${berita.idBerita}";

                                  await Share.share(
                                      "Baca berita menarik ini di MediaExplant:\n\n${berita.judul}\n$url");
                                },
                              ),

                              const SizedBox(width: 10),
                            ],
                          ),

                          // Tag berita
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Wrap(
                              spacing: 8.0,
                              runSpacing: 8.0,
                              children: berita.tags.map((tag) {
                                return ActionChip(
                                  onPressed: () {},
                                  label: Text(
                                    tag,
                                    style: const TextStyle(
                                        color: AppColors.primary),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    side: const BorderSide(color: Colors.grey),
                                  ),
                                  backgroundColor: AppColors.background,
                                );
                              }).toList(),
                            ),
                          ),
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
                  padding: const EdgeInsets.only(left: 15, top: 15, bottom: 10),
                  child: titleHeader("Berita Terkait", "mungkin anda suka")),
            ),
            // BERITA terkait
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return ChangeNotifierProvider.value(
                      value: beritaTerkaitList[index],
                      child: BeritaPopulerItem(),
                    );
                  },
                  childCount: beritaTerkaitList.length,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      final beritaId = berita.idBerita;
                      final kategori = berita.kategori;

                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) {
                          final viewModel = BeritaSelengkapnyaViewModel();
                          return ChangeNotifierProvider<
                              BeritaSelengkapnyaViewModel>(
                            create: (_) {
                              // Pastikan parameter lengkap dikirim di awal
                              viewModel.setKategori(
                                KategoriBerita.terkait,
                                beritaId: beritaId,
                                kategoriBerita: kategori,
                              );
                              return viewModel;
                            },
                            child: BeritaSelengkapnya(
                              kategori: KategoriBerita.terkait,
                              beritaIdTerkait: beritaId,
                              kategoriTerkait: kategori,
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

            // berita terbaru
            SliverPadding(
              padding: const EdgeInsets.only(top: 20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Container(
                    color: Colors.grey.withAlpha(50),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 15, top: 20, bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          titleHeader("Topik Lainnya", "Teratas untuk anda"),
                          const SizedBox(height: 10),
                          // BERITA TERBARU
                          SizedBox(
                            height: 200,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 10,
                              itemBuilder: (context, index) {
                                return ChangeNotifierProvider.value(
                                  value: beritaTopikLainnyaList[index],
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
                                  final beritaId = berita.idBerita;
                                  final kategori = berita.kategori;

                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) {
                                      final viewModel =
                                          BeritaSelengkapnyaViewModel();
                                      return ChangeNotifierProvider<
                                          BeritaSelengkapnyaViewModel>(
                                        create: (_) {
                                          // Pastikan parameter lengkap dikirim di awal
                                          viewModel.setKategori(
                                            KategoriBerita.topiklainnya,
                                            beritaId: beritaId,
                                            kategoriBerita: kategori,
                                          );
                                          return viewModel;
                                        },
                                        child: BeritaSelengkapnya(
                                          kategori: KategoriBerita.topiklainnya,
                                          beritaIdTerkait: beritaId,
                                          kategoriTerkait: kategori,
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
                          const SizedBox(
                            height: 50,
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
              'Berita',
              berita.idBerita,
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
