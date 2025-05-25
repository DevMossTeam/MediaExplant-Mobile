import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mediaexplant/core/constants/app_colors.dart';
import 'package:mediaexplant/core/utils/userID.dart';
import 'package:mediaexplant/features/bookmark/models/bookmark.dart';
import 'package:mediaexplant/features/bookmark/provider/bookmark_provider.dart';
import 'package:mediaexplant/features/comments/presentation/logic/komentar_viewmodel.dart';
import 'package:mediaexplant/features/home/models/berita/berita.dart';
import 'package:mediaexplant/features/comments/presentation/ui/screens/komentar_screen.dart';
import 'package:mediaexplant/features/home/presentation/logic/viewmodel/berita/berita_terbaru_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/logic/viewmodel/berita/berita_terkait_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/ui/screens/berita_selengkapnya.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita/berita_populer_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita/berita_terbaru_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/title_header_widget.dart';
import 'package:mediaexplant/features/reaksi/models/reaksi.dart';
import 'package:mediaexplant/features/reaksi/provider/Reaksi_provider.dart';
import 'package:mediaexplant/features/report/report_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';


class DetailBeritaScreen extends StatefulWidget {
  const DetailBeritaScreen({super.key});

  @override
  State<DetailBeritaScreen> createState() => _DetailBeritaScreenState();
}

class _DetailBeritaScreenState extends State<DetailBeritaScreen> {
  @override
  void initState() {
    super.initState();

    final berita = Provider.of<Berita>(context, listen: false);
    final beritaTerkaitViewmodel =
        Provider.of<BeritaTerkaitViewmodel>(context, listen: false);
    beritaTerkaitViewmodel.fetchBeritaTerkait(
        userLogin, berita.kategori, berita.idBerita);

    final beritaTerbaruViewmodel =
        Provider.of<BeritaTerbaruViewmodel>(context, listen: false);
    beritaTerbaruViewmodel.fetchBeritaTerbaru(userLogin);
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
    final beritaTerkaitViewmodel = Provider.of<BeritaTerkaitViewmodel>(context);
    final beritaTerkaitList = beritaTerkaitViewmodel.allBerita;

    final beritaTerbaruViewmodel = Provider.of<BeritaTerbaruViewmodel>(context);
    final beritaTerbaruList = beritaTerbaruViewmodel.allBerita;

    final bookmarkProvider =
        Provider.of<BookmarkProvider>(context, listen: false);
    final reaksiProvider = Provider.of<ReaksiProvider>(context, listen: false);
    final berita = Provider.of<Berita>(context);
    String kontenTanpaGambar = removeFirstImageFromKonten(berita.kontenBerita);
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
                      imageUrl: berita.gambar ??
                          berita.firstImageFromKonten ??
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
                      Bookmark(
                        userId: userLogin,
                        itemId: berita.idBerita,
                        bookmarkType: "Berita",
                      ),
                    );

                    berita.statusBookmark();
                  },
                  icon: Icon(
                    berita.isBookmark ? Icons.bookmark : Icons.bookmark_outline,
                    color: Colors.white,
                  ),
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
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20))),
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
                          'Oleh: ${berita.penulis}  |  ${berita.tanggalDibuat}',
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
                                  itemId: berita.idBerita,
                                  jenisReaksi: "Suka",
                                  reaksiType: "Berita",
                                ));
                                berita.statusLike();
                              },
                              icon: Icon(
                                Icons.thumb_up,
                                color:
                                    berita.isLike ? Colors.blue : Colors.grey,
                              ),
                            ),
                            Text(
                              '${berita.jumlahLike}',
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
                                  itemId: berita.idBerita,
                                  jenisReaksi: "Tidak Suka",
                                  reaksiType: "Berita",
                                ));
                                berita.statusDislike();
                              },
                              icon: Icon(
                                Icons.thumb_down,
                                color:
                                    berita.isDislike ? Colors.red : Colors.grey,
                              ),
                            ),

                            Text(
                              '${berita.jumlahDislike}',
                              style: const TextStyle(color: Colors.red),
                            ),
                            const SizedBox(width: 10),

                            IconButton(
                              icon: const Icon(Icons.share, color: Colors.blue),
                              onPressed: () {
                                final berita =
                                    Provider.of<Berita>(context, listen: false);
                                final String shareText = '${berita.judul}\n\n'
                                    'Baca selengkapnya di aplikasi MediaExplant.\n\n'
                                    'Kategori: ${berita.kategori}\n'
                                    'Penulis: ${berita.penulis}';
                                Share.share(shareText);
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
                  onPressed: () async {
                    final beritaId = berita.idBerita;
                    final kategori = berita.kategori;
                    final viewModel = BeritaSelengkapnyaViewModel();
                    await viewModel.setKategori(KategoriBerita.terkait);

                    if (!mounted) return;

                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) {
                        return ChangeNotifierProvider<
                            BeritaSelengkapnyaViewModel>.value(
                          value: viewModel,
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
                        titleHeader("Terbaru", "Teratas untuk anda"),
                        const SizedBox(height: 10),
                        // BERITA TERBARU
                        SizedBox(
                          height: 200,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              return ChangeNotifierProvider.value(
                                value: beritaTerbaruList[index],
                                child: BeritaTerbaruItem(),
                              );
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () async {
                                final viewModel = BeritaSelengkapnyaViewModel();
                                if (!mounted) return;
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) {
                                    return ChangeNotifierProvider<
                                        BeritaSelengkapnyaViewModel>.value(
                                      value: viewModel,
                                      child: const BeritaSelengkapnya(
                                        kategori: KategoriBerita.terbaru,
                                      ),
                                    );
                                  }),
                                );
                                Future.microtask(() async {
                                  await viewModel
                                      .setKategori(KategoriBerita.terbaru);
                                });
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
