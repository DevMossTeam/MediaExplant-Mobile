import 'package:flutter/material.dart';
import 'package:mediaexplant/core/constants/app_colors.dart';
import 'package:mediaexplant/core/utils/userID.dart';
import 'package:mediaexplant/features/home/presentation/logic/viewmodel/berita/berita_populer_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/logic/viewmodel/berita/berita_dari_kami_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/logic/viewmodel/berita/berita_hot_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/logic/viewmodel/berita/berita_teratas_view_model.dart';
import 'package:mediaexplant/features/home/presentation/logic/viewmodel/berita/berita_terbaru_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/ui/screens/berita_selengkapnya.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita/berita_populer_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita/berita_rekomandasi_lain_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita/berita_terbaru_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita/berita_terkini_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita/shimmer_berita.item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/title_header_widget.dart';
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
    final beritaHotVM = Provider.of<BeritaHotViewmodel>(context, listen: false);

    try {
      if (beritaTeratasVM.allBerita.isEmpty) {
        setState(() => _isLoading['teratas'] = true);
        try {
          await beritaTeratasVM.refresh(userLogin);
        } catch (e) {
          debugPrint('Error fetchBeritaTeratas: $e');
        } finally {
          setState(() => _isLoading['teratas'] = false);
        }
      }

      if (beritaPopulerVM.allBerita.isEmpty) {
        setState(() => _isLoading['populer'] = true);
        try {
          await beritaPopulerVM.refresh(userLogin);
        } catch (e) {
          debugPrint('Error fetchBeritaPopuler: $e');
        } finally {
          setState(() => _isLoading['populer'] = false);
        }
      }

      if (beritaTerbaruVM.allBerita.isEmpty) {
        setState(() => _isLoading['terbaru'] = true);
        try {
          await beritaTerbaruVM.refresh(userLogin);
        } catch (e) {
          debugPrint('Error fetchBeritaTerbaru: $e');
        } finally {
          setState(() => _isLoading['terbaru'] = false);
        }
      }

      if (beritaRekomendasiVM.allBerita.isEmpty) {
        setState(() => _isLoading['rekomendasi'] = true);
        try {
          await beritaRekomendasiVM.refresh(userLogin);
        } catch (e) {
          debugPrint('Error fetchBeritaDariKami: $e');
        } finally {
          setState(() => _isLoading['rekomendasi'] = false);
        }
      }

      if (beritaHotVM.allBerita.isEmpty) {
        setState(() => _isLoading['rekomendasiLain'] = true);
        try {
          await beritaHotVM.refresh(userLogin);
        } catch (e) {
          debugPrint('Error fetchBeritaHot: $e');
        } finally {
          setState(() => _isLoading['rekomendasiLain'] = false);
        }
      }
    } catch (e) {
      debugPrint('Unexpected error: $e');
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
        Provider.of<BeritaHotViewmodel>(context).allBerita;

    return RefreshIndicator(
      onRefresh: _fetchBeritaSecaraBerurutan,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: SizedBox(height: 10)),

          // Berita teratas
          if (_isLoading['teratas']! || _isLoading['populer']!)
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => ShimmerBeritaItem(),
                childCount: 1,
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => ChangeNotifierProvider.value(
                  value: beritaTeratas[index],
                  child: BeritaTerkiniItem(),
                ),
                childCount: 1,
              ),
            ),

          SliverToBoxAdapter(child: SizedBox(height: 20)),

          if (_isLoading['populer']!)
            const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator()))
          else ...[
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              sliver: SliverToBoxAdapter(
                child: titleHeader("Terpopuler", "5 Teratas untuk anda"),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 10)),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
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
                      Expanded(
                        child: ChangeNotifierProvider.value(
                          value: beritaPopulerList[index],
                          child: BeritaPopulerItem(),
                        ),
                      ),
                    ],
                  ),
                  childCount: beritaPopulerList.length,
                ),
              ),
            ),
          ],

          SliverToBoxAdapter(child: SizedBox(height: 20)),

          if (_isLoading['terbaru']!)
            const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator()))
          else
            SliverToBoxAdapter(
              child: Container(
                color: Colors.grey.withAlpha(50),
                padding: const EdgeInsets.only(left: 15, top: 20, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titleHeader("Terbaru", "Yang baru saja terbit"),
                    const SizedBox(height: 20),
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
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  ChangeNotifierProvider.value(
                                value: viewModel,
                                child: const BeritaSelengkapnya(
                                  kategori: KategoriBerita.terbaru,
                                ),
                              ),
                            ));
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
                    )
                  ],
                ),
              ),
            ),

          SliverToBoxAdapter(child: SizedBox(height: 20)),

          if (_isLoading['rekomendasi']!)
            const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator()))
          else ...[
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              sliver: SliverToBoxAdapter(
                child: titleHeader("Direkomendasikan", "Mungkin anda suka"),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 10)),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => ChangeNotifierProvider.value(
                    value: beritaRekomendasiList[index],
                    child: BeritaPopulerItem(),
                  ),
                  childCount: beritaRekomendasiList.length,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Row(
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
                              kategori: KategoriBerita.rekomendasi,
                            ),
                          );
                        }),
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
            ),
          ],

          SliverToBoxAdapter(child: SizedBox(height: 20)),

          if (_isLoading['rekomendasiLain']!)
            const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator()))
          else ...[
            SliverToBoxAdapter(
              child: Container(
                color: Colors.grey.withAlpha(50),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, top: 20, bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      titleHeader("Berita Hot", "Paling banyak dikomentari"),
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
                                MaterialPageRoute(builder: (context) {
                                  return ChangeNotifierProvider<
                                      BeritaSelengkapnyaViewModel>.value(
                                    value: viewModel,
                                    child: const BeritaSelengkapnya(
                                      kategori: KategoriBerita.rekomendasiLain,
                                    ),
                                  );
                                }),
                              );
                              Future.microtask(() async {
                                await viewModel.setKategori(
                                    KategoriBerita.rekomendasiLain);
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
            ),
          ],
        ],
      ),
    );
  }
}
