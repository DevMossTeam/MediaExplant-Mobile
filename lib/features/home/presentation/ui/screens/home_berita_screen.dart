import 'package:flutter/material.dart';
import 'package:mediaexplant/core/constants/app_colors.dart';
import 'package:mediaexplant/features/home/presentation/logic/viewmodel/berita/berita_populer_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/logic/viewmodel/berita/berita_dari_kami_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/logic/viewmodel/berita/berita_rekomendasi_lain_view_model.dart';
import 'package:mediaexplant/features/home/presentation/logic/viewmodel/berita/berita_teratas_view_model.dart';
import 'package:mediaexplant/features/home/presentation/logic/viewmodel/berita/berita_terbaru_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/ui/screens/berita_selengkapnya.dart';
import 'package:mediaexplant/features/home/presentation/ui/screens/home_screen.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita/berita_populer_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita/berita_rekomandasi_lain_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita/berita_terbaru_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita/berita_terkini_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita/shimmer_berita.item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/title_header_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class HomeBeritaScreen extends StatefulWidget {
  const HomeBeritaScreen({super.key});

  @override
  State<HomeBeritaScreen> createState() => _HomeBeritaScreenState();
}

class _HomeBeritaScreenState extends State<HomeBeritaScreen>
    with AutomaticKeepAliveClientMixin {
  var _isInit = true;

  final Map<String, bool> _isLoading = {
    'teratas': false,
    'terbaru': false,
    'populer': false,
    'rekomendasi': false,
    'rekomendasiLain': false,
  };

  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInit) {
      _fetchBeritaSecaraBerurutan();

      _isInit = false;
    }
  }

  Future<void> _fetchBeritaSecaraBerurutan() async {
    final beritaTeratasVM =
        Provider.of<BeritaTeratasViewModel>(context, listen: false);
    final beritaTerbaruVM =
        Provider.of<BeritaTerbaruViewmodel>(context, listen: false);
    final beritaPopulerVM =
        Provider.of<BeritaPopulerViewmodel>(context, listen: false);
    final beritaRekomendasiVM =
        Provider.of<BeritaDariKamiViewmodel>(context, listen: false);
    final beritaRekomendasiLainVM =
        Provider.of<BeritaRekomendasiLainViewModel>(context, listen: false);

    if (beritaTeratasVM.allBerita.isEmpty) {
      setState(() => _isLoading['teratas'] = true);
      await beritaTeratasVM.fetchBeritaTeratas(userLogin);
      setState(() => _isLoading['teratas'] = false);
    }

    if (beritaTerbaruVM.allBerita.isEmpty) {
      setState(() => _isLoading['terbaru'] = true);
      await beritaTerbaruVM.fetchBeritaTerbaru(userLogin);
      setState(() => _isLoading['terbaru'] = false);
    }

    if (beritaPopulerVM.allBerita.isEmpty) {
      setState(() => _isLoading['populer'] = true);
      await beritaPopulerVM.fetchBeritaPopuler(userLogin);
      setState(() => _isLoading['populer'] = false);
    }

    if (beritaRekomendasiVM.allBerita.isEmpty) {
      setState(() => _isLoading['rekomendasi'] = true);
      await beritaRekomendasiVM.fetchBeritaDariKami(userLogin);
      setState(() => _isLoading['rekomendasi'] = false);
    }

    if (beritaRekomendasiLainVM.allBerita.isEmpty) {
      setState(() => _isLoading['rekomendasiLain'] = true);
      await beritaRekomendasiLainVM.fetchBeritaRekomendasiLain(userLogin);
      setState(() => _isLoading['rekomendasiLain'] = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final beritaTeratas =
        Provider.of<BeritaTeratasViewModel>(context).allBerita;
    final beritaTerbaruList =
        Provider.of<BeritaTerbaruViewmodel>(context).allBerita;
    final beritaPopulerList =
        Provider.of<BeritaPopulerViewmodel>(context).allBerita;
    final beritaRekomendasiList =
        Provider.of<BeritaDariKamiViewmodel>(context).allBerita;
    final beritaRekomendasiLainList =
        Provider.of<BeritaRekomendasiLainViewModel>(context).allBerita;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),

          // Berita teratas
          if (_isLoading['teratas']! || _isLoading['terbaru']!)
            // Tampilkan shimmer loading
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 1,
              itemBuilder: (context, index) {
                return ShimmerBeritaItem();
              },
            )
          else ...[
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 1,
              itemBuilder: (context, index) {
                return ChangeNotifierProvider.value(
                  value: beritaTeratas[index],
                  child: BeritaTerkiniItem(),
                );
              },
            ),
          ],

          // terpopuler 5 teratas
          const SizedBox(height: 20),

          if (_isLoading['terbaru']!)
            const Center(child: CircularProgressIndicator())
          else ...[
            Container(
              color: Colors.grey.withAlpha(50),
              child: Padding(
                padding: const EdgeInsets.only(left: 15, top: 20, bottom: 20),
                child: Column(
                  children: [
                    titleHeader("Terbaru", "Teratas untuk anda"),
                    const SizedBox(
                      height: 20,
                    ),
                    // berita terbaru
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: beritaTerbaruList.length,
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
                              PageTransition(
                                type: PageTransitionType.rightToLeftWithFade,
                                duration: const Duration(milliseconds: 500),
                                reverseDuration:
                                    const Duration(milliseconds: 500),
                                child: ChangeNotifierProvider<
                                    BeritaSelengkapnyaViewModel>.value(
                                  value: viewModel,
                                  child: const BeritaSelengkapnya(
                                    kategori: KategoriBerita.terbaru,
                                  ),
                                ),
                              ),
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
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],

          const SizedBox(
            height: 20,
          ),
          // Dari Kami mungkin anda suka

          if (_isLoading['populer']!)
            const Center(child: CircularProgressIndicator())
          else ...[
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: titleHeader("Terpopuler", "5 Teratas untuk anda")),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: beritaPopulerList.length,
                itemBuilder: (context, index) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Nomor Indexing
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 5),
                        child: Text(
                          "${index + 1}",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // Item Berita
                      Expanded(
                        child: ChangeNotifierProvider.value(
                          value: beritaPopulerList[index],
                          child: BeritaPopulerItem(),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
          const SizedBox(height: 20),

          if (_isLoading['rekomendasi']!)
            const Center(child: CircularProgressIndicator())
          else ...[
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: titleHeader("Dari Kami", "Mungkin anda suka")),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: beritaRekomendasiList.length,
                itemBuilder: (context, index) {
                  return ChangeNotifierProvider.value(
                    value: beritaRekomendasiList[index],
                    child: BeritaPopulerItem(),
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
                      PageTransition(
                        type: PageTransitionType.rightToLeftWithFade,
                        duration: const Duration(milliseconds: 500),
                        reverseDuration: const Duration(milliseconds: 500),
                        child: ChangeNotifierProvider<
                            BeritaSelengkapnyaViewModel>.value(
                          value: viewModel,
                          child: const BeritaSelengkapnya(
                            kategori: KategoriBerita.rekomendasi,
                          ),
                        ),
                      ),
                    );
                    Future.microtask(() async {
                      await viewModel.setKategori(KategoriBerita.rekomendasi);
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
          ],

          const SizedBox(
            height: 20,
          ),

          // berita rekomandasi lainnya
          if (_isLoading['rekomendasiLain']!)
            const Center(child: CircularProgressIndicator())
          else ...[
            Container(
              color: Colors.grey.withAlpha(50),
              child: Padding(
                padding: const EdgeInsets.only(left: 15, top: 20, bottom: 20),
                child: Column(
                  children: [
                    titleHeader("Rekomendasi Lain", "Mungkin anda suka"),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: beritaRekomendasiLainList.length,
                        itemBuilder: (context, index) {
                          return ChangeNotifierProvider.value(
                            value: beritaRekomendasiLainList[index],
                            child: BeritaRekomandasiLainItem(),
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
                              PageTransition(
                                type: PageTransitionType.rightToLeftWithFade,
                                duration: const Duration(milliseconds: 500),
                                reverseDuration:
                                    const Duration(milliseconds: 500),
                                child: ChangeNotifierProvider<
                                    BeritaSelengkapnyaViewModel>.value(
                                  value: viewModel,
                                  child: const BeritaSelengkapnya(
                                    kategori: KategoriBerita.rekomendasiLain,
                                  ),
                                ),
                              ),
                            );
                            Future.microtask(() async {
                              await viewModel
                                  .setKategori(KategoriBerita.rekomendasiLain);
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
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
