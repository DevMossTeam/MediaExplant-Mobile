import 'package:connectivity_plus/connectivity_plus.dart';
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
  bool _isOffline = false;

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
      _checkConnection();
      _fetchBeritaSecaraBerurutan();

      _isInit = false;
    }
  }

  Future<void> _checkConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isOffline = connectivityResult == ConnectivityResult.none;
    });
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
      // Teratas
      setState(() => _isLoading['teratas'] = true);
      await beritaTeratasVM.refresh(userLogin);
      setState(() => _isLoading['teratas'] = false);

      // Populer
      setState(() => _isLoading['populer'] = true);
      await beritaPopulerVM.refresh(userLogin);
      setState(() => _isLoading['populer'] = false);

      // Terbaru
      setState(() => _isLoading['terbaru'] = true);
      await beritaTerbaruVM.refresh(userLogin);
      setState(() => _isLoading['terbaru'] = false);

      // Rekomendasi
      setState(() => _isLoading['rekomendasi'] = true);
      await beritaRekomendasiVM.refresh(userLogin);
      setState(() => _isLoading['rekomendasi'] = false);

      // Rekomendasi Lain
      setState(() => _isLoading['rekomendasiLain'] = true);
      await beritaHotVM.refresh(userLogin);
      setState(() => _isLoading['rekomendasiLain'] = false);
    } catch (e) {
      debugPrint('Error saat refresh: $e');
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
      onRefresh: () async {
        await _fetchBeritaSecaraBerurutan();
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
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
          else if (beritaTeratas.isEmpty)
            SliverToBoxAdapter(
              child: Center(
                child: Text(
                  _isOffline
                      ? 'Tidak ada koneksi internet.'
                      : 'Gagal memuat berita teratas.',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
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
          else if (beritaPopulerList.isEmpty)
            SliverToBoxAdapter(
              child: Center(
                child: Text(
                  _isOffline
                      ? 'Tidak ada koneksi internet.'
                      : 'Gagal memuat berita populer.',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            )
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
          else if (beritaTerbaruList.isEmpty)
            SliverToBoxAdapter(
              child: Center(
                child: Text(
                  _isOffline
                      ? 'Tidak ada koneksi internet.'
                      : 'Gagal memuat berita terbaru.',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            )
          else
            SliverToBoxAdapter(
              child: Container(
                color: Colors.grey.withAlpha(50),
                padding: const EdgeInsets.only(left: 15, top: 20, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titleHeader("Terbaru", "Dari yang terbaru"),
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
          else if (beritaRekomendasiList.isEmpty)
            SliverToBoxAdapter(
              child: Center(
                child: Text(
                  _isOffline
                      ? 'Tidak ada koneksi internet.'
                      : 'Gagal memuat berita rekomendasi.',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            )
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
          else if (beritaRekomendasiLainList.isEmpty)
            SliverToBoxAdapter(
              child: Center(
                child: Text(
                  _isOffline
                      ? 'Tidak ada koneksi internet.'
                      : 'Gagal memuat berita hot.',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            )
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
