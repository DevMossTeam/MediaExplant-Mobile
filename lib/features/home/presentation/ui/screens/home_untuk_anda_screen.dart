import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:mediaexplant/core/constants/app_colors.dart';
import 'package:mediaexplant/core/utils/userID.dart';
import 'package:mediaexplant/features/home/presentation/logic/viewmodel/berita/berita_terbaru_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/logic/viewmodel/karya/desain_grafis_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/logic/viewmodel/karya/fotografi_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/logic/viewmodel/karya/pantun_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/logic/viewmodel/karya/puisi_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/logic/viewmodel/karya/syair_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/logic/viewmodel/produk/buletin_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/logic/viewmodel/produk/majalah_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/ui/screens/karya_selengkapnya.dart';
import 'package:mediaexplant/features/home/presentation/ui/screens/produk_selengkapnya.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita/berita_rekomendasi_untuk_anda_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita/berita_teratas_untuk_anda.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita/shimmer_berita.item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/karya/desain_grafis_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/karya/fotografi_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/karya/puisi_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/produk/produk_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/title_header_widget.dart';
import 'package:provider/provider.dart';

class HomeUntukAndaScreen extends StatefulWidget {
  const HomeUntukAndaScreen({super.key});

  @override
  State<HomeUntukAndaScreen> createState() => _HomeUntukAndaScreenState();
}

class _HomeUntukAndaScreenState extends State<HomeUntukAndaScreen>
    with AutomaticKeepAliveClientMixin<HomeUntukAndaScreen> {
  var _isInit = true;
  bool _isOffline = false;
  final Map<String, bool> _isLoading = {
    'berita': false,
    'majalah': false,
    'buletin': false,
    'puisi': false,
    'syair': false,
    'pantun': false,
    'desain_grafis': false,
    'fotografi': false,
  };

  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInit) {
      _checkConnection();
      _fetchKontenSecaraBerurutan();

      _isInit = false;
    }
  }

  Future<void> _checkConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isOffline = connectivityResult == ConnectivityResult.none;
    });
  }

  Future<void> _fetchKontenSecaraBerurutan() async {
    final beritaVM =
        Provider.of<BeritaTerbaruViewmodel>(context, listen: false);
    final puisiVM = Provider.of<PuisiViewmodel>(context, listen: false);
    final syairVM = Provider.of<SyairViewmodel>(context, listen: false);
    final pantunVM = Provider.of<PantunViewmodel>(context, listen: false);
    final desainGrafisVM =
        Provider.of<DesainGrafisViewmodel>(context, listen: false);
    final fotografiVM = Provider.of<FotografiViewmodel>(context, listen: false);
    final majalahVM = Provider.of<MajalahViewmodel>(context, listen: false);
    final buletinVM = Provider.of<BuletinViewmodel>(context, listen: false);

    try {
      // Berita
      setState(() => _isLoading['berita'] = true);
      await beritaVM.refresh(userLogin);
      setState(() => _isLoading['berita'] = false);

      // Puisi
      setState(() => _isLoading['puisi'] = true);
      await puisiVM.refresh(userLogin);
      setState(() => _isLoading['puisi'] = false);

      // Syair
      setState(() => _isLoading['syair'] = true);
      await syairVM.refresh(userLogin);
      setState(() => _isLoading['syair'] = false);

      // Pantun
      setState(() => _isLoading['pantun'] = true);
      await pantunVM.refresh(userLogin);
      setState(() => _isLoading['pantun'] = false);

      // Desain Grafis
      setState(() => _isLoading['desain_grafis'] = true);
      await desainGrafisVM.refresh(userLogin);
      setState(() => _isLoading['desain_grafis'] = false);

      // Fotografi
      setState(() => _isLoading['fotografi'] = true);
      await fotografiVM.refresh(userLogin);
      setState(() => _isLoading['fotografi'] = false);

      // Majalah
      setState(() => _isLoading['majalah'] = true);
      await majalahVM.refresh(userLogin);
      setState(() => _isLoading['majalah'] = false);

      // Buletin
      setState(() => _isLoading['buletin'] = true);
      await buletinVM.refresh(userLogin);
      setState(() => _isLoading['buletin'] = false);
    } catch (e) {
      debugPrint("Gagal fetch konten: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final beritaList = Provider.of<BeritaTerbaruViewmodel>(context).allBerita;
    final majalahList = Provider.of<MajalahViewmodel>(context).allMajalah;
    final buletinList = Provider.of<BuletinViewmodel>(context).allBuletin;
    final puisiList = Provider.of<PuisiViewmodel>(context).allKarya;
    final syairList = Provider.of<SyairViewmodel>(context).allKarya;
    final pantunList = Provider.of<PantunViewmodel>(context).allKarya;
    final desainGrafisList =
        Provider.of<DesainGrafisViewmodel>(context).allKarya;
    final fotografiList = Provider.of<FotografiViewmodel>(context).allKarya;

    return RefreshIndicator(
      onRefresh: () async {
        await _fetchKontenSecaraBerurutan();
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          const SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),

          // Berita loading atau list horizontal rekomendasi berita
          if (_isLoading['berita']! || _isLoading['puisi']!)
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => ShimmerBeritaItem(),
                childCount: 1,
              ),
            )
          else if (beritaList.isEmpty)
            SliverToBoxAdapter(
              child: Center(
                child: Text(
                  _isOffline
                      ? 'Tidak ada koneksi internet.'
                      : 'Gagal memuat berita .',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            )
          else ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: titleHeader("Berita", "Dari yang terbaru"),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: SizedBox(
                  height: 180,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: beritaList.length.clamp(0, 10),
                    itemBuilder: (context, index) {
                      return ChangeNotifierProvider.value(
                        value: beritaList[index],
                        child: BeritaRekomendasiUntukAndaItem(),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 20),
            ),
            // SliverToBoxAdapter(
            //   child: Container(
            //     color: Colors.grey.withAlpha(50),
            //     padding: const EdgeInsets.only(left: 15, top: 20, bottom: 20),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         titleHeader("Berita", "Teratas untuk anda"),
            //         const SizedBox(height: 20),
            //         SizedBox(
            //           height: 200, // tinggi 1 item grid
            //           child: GridView.builder(
            //               itemCount: beritaList.length.clamp(0, 10),
            //               shrinkWrap: true,
            //               scrollDirection: Axis.horizontal,
            //               gridDelegate:
            //                   const SliverGridDelegateWithFixedCrossAxisCount(
            //                       mainAxisSpacing: 10,
            //                       crossAxisSpacing: 10,
            //                       childAspectRatio: 0.27,
            //                       crossAxisCount: 2),
            //               itemBuilder: (contex, index) {
            //                 return ChangeNotifierProvider.value(
            //                   value: beritaList[index],
            //                   child: BeritaTeratasUntukAnda(),
            //                 );
            //               }),
            //         ),
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.end,
            //           children: [
            //             TextButton(
            //               onPressed: () {
            //                 // aksi saat tombol ditekan
            //                 print("Tombol ditekan");
            //               },
            //               child: const Text(
            //                 "Selengkapnya >>",
            //                 style: TextStyle(
            //                   color: AppColors.primary,
            //                   fontSize: 14,
            //                 ),
            //               ),
            //             ),
            //           ],
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 30),
            ),
          ],

          // Puisi Terbaru
          if (_isLoading['puisi']!)
            const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator()))
          else if (puisiList.isEmpty)
            SliverToBoxAdapter(
              child: Center(
                child: Text(
                  _isOffline
                      ? 'Tidak ada koneksi internet.'
                      : 'Gagal memuat puisi .',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            )
          else ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: titleHeader("Puisi", "Dari yang terbaru"),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: SizedBox(
                  height: 240,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: puisiList.length.clamp(0, 10),
                    itemBuilder: (context, index) {
                      return ChangeNotifierProvider.value(
                        value: puisiList[index],
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
                    onPressed: () async {
                      final viewModel = KaryaSelengkapnyaViewModel();
                      if (!mounted) return;
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider.value(
                          value: viewModel,
                          child: const KaryaSelengkapnya(
                            kategori: KategoriKarya.puisi,
                          ),
                        ),
                      ));
                      Future.microtask(() async {
                        await viewModel.setKategori(KategoriKarya.puisi);
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
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 30),
            ),
          ],

          // Syair Terbaru
          if (_isLoading['syair']!)
            const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator()))
          else if (syairList.isEmpty)
            SliverToBoxAdapter(
              child: Center(
                child: Text(
                  _isOffline
                      ? 'Tidak ada koneksi internet.'
                      : 'Gagal memuat syair .',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            )
          else ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: titleHeader("Syair", "Dari yang terbaru"),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: SizedBox(
                  height: 240,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: syairList.length.clamp(0, 10),
                    itemBuilder: (context, index) {
                      return ChangeNotifierProvider.value(
                        value: syairList[index],
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
                    onPressed: () async {
                      final viewModel = KaryaSelengkapnyaViewModel();
                      if (!mounted) return;
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider.value(
                          value: viewModel,
                          child: const KaryaSelengkapnya(
                            kategori: KategoriKarya.syair,
                          ),
                        ),
                      ));
                      Future.microtask(() async {
                        await viewModel.setKategori(KategoriKarya.syair);
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
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 30),
            ),
          ],

          // pantun Terbaru
          if (_isLoading['pantun']!)
            const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator()))
          else if (pantunList.isEmpty)
            SliverToBoxAdapter(
              child: Center(
                child: Text(
                  _isOffline
                      ? 'Tidak ada koneksi internet.'
                      : 'Gagal memuat pantun .',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            )
          else ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: titleHeader("Pantun", "Dari yang terbaru"),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: SizedBox(
                  height: 240,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: pantunList.length.clamp(0, 10),
                    itemBuilder: (context, index) {
                      return ChangeNotifierProvider.value(
                        value: pantunList[index],
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
                    onPressed: () async {
                      final viewModel = KaryaSelengkapnyaViewModel();
                      if (!mounted) return;
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider.value(
                          value: viewModel,
                          child: const KaryaSelengkapnya(
                            kategori: KategoriKarya.pantun,
                          ),
                        ),
                      ));
                      Future.microtask(() async {
                        await viewModel.setKategori(KategoriKarya.pantun);
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
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 30),
            ),
          ],

          // Desain Grafis
          if (_isLoading['desain_grafis']!)
            const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator()))
          else if (desainGrafisList.isEmpty)
            SliverToBoxAdapter(
              child: Center(
                child: Text(
                  _isOffline
                      ? 'Tidak ada koneksi internet.'
                      : 'Gagal memuat desain grafis .',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            )
          else ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: titleHeader("Desain Grafis", "Dari yang terbaru"),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: SizedBox(
                  height: 210,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: desainGrafisList.length.clamp(0, 10),
                    itemBuilder: (context, index) {
                      return ChangeNotifierProvider.value(
                        value: desainGrafisList[index],
                        child: DesainGrafisItem(),
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
                    onPressed: () async {
                      final viewModel = KaryaSelengkapnyaViewModel();
                      if (!mounted) return;
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider.value(
                          value: viewModel,
                          child: const KaryaSelengkapnya(
                            kategori: KategoriKarya.desainGrafis,
                          ),
                        ),
                      ));
                      Future.microtask(() async {
                        await viewModel.setKategori(KategoriKarya.desainGrafis);
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
            ),
          ],
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 20,
            ),
          ),

          // Fotografi
          if (_isLoading['fotografi']!)
            const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator()))
          else if (fotografiList.isEmpty)
            SliverToBoxAdapter(
              child: Center(
                child: Text(
                  _isOffline
                      ? 'Tidak ada koneksi internet.'
                      : 'Gagal memuat fotografi .',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            )
          else ...[
            SliverToBoxAdapter(
              child: Container(
                color: Colors.grey.withAlpha(50),
                padding: const EdgeInsets.only(left: 15, top: 20, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titleHeader("Fotografi", "Dari yang terbaru"),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 190,
                      child: GridView.builder(
                          itemCount: fotografiList.length.clamp(0, 10),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10,
                                  childAspectRatio: 0.27,
                                  crossAxisCount: 2),
                          itemBuilder: (contex, index) {
                            return ChangeNotifierProvider.value(
                              value: fotografiList[index],
                              child: FotografiItem(),
                            );
                          }),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () async {
                            final viewModel = KaryaSelengkapnyaViewModel();
                            if (!mounted) return;
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  ChangeNotifierProvider.value(
                                value: viewModel,
                                child: const KaryaSelengkapnya(
                                  kategori: KategoriKarya.fotografi,
                                ),
                              ),
                            ));
                            Future.microtask(() async {
                              await viewModel
                                  .setKategori(KategoriKarya.fotografi);
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
            const SliverToBoxAdapter(
              child: SizedBox(height: 30),
            ),
            // Produk Majalah
            if (_isLoading['majalah']!)
              const SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()))
            else if (majalahList.isEmpty)
              SliverToBoxAdapter(
                child: Center(
                  child: Text(
                    _isOffline
                        ? 'Tidak ada koneksi internet.'
                        : 'Gagal memuat majalah .',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              )
            else ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: titleHeader("Majalah", "Dari yang terbaru"),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: SizedBox(
                    height: 240,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: majalahList.length.clamp(0, 10),
                      itemBuilder: (context, index) {
                        return ChangeNotifierProvider.value(
                          value: majalahList[index],
                          child: ProdukItem(),
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
                      onPressed: () async {
                        final viewModel = ProdukSelengkapnyaViewModel();
                        if (!mounted) return;
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ChangeNotifierProvider.value(
                            value: viewModel,
                            child: const ProdukSelengkapnya(
                              kategori: KategoriProduk.majalah,
                            ),
                          ),
                        ));
                        Future.microtask(() async {
                          await viewModel.setKategori(KategoriProduk.majalah);
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
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 30),
              ),
            ],

            // Produk Buletin
            if (_isLoading['buletin']!)
              const SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()))
            else if (buletinList.isEmpty)
              SliverToBoxAdapter(
                child: Center(
                  child: Text(
                    _isOffline
                        ? 'Tidak ada koneksi internet.'
                        : 'Gagal memuat buletin .',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              )
            else ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: titleHeader("Buletin", "Dari yang terbaru"),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: SizedBox(
                    height: 240,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: buletinList.length.clamp(0, 10),
                      itemBuilder: (context, index) {
                        return ChangeNotifierProvider.value(
                          value: buletinList[index],
                          child: ProdukItem(),
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
                      onPressed: () async {
                        final viewModel = ProdukSelengkapnyaViewModel();
                        if (!mounted) return;
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ChangeNotifierProvider.value(
                            value: viewModel,
                            child: const ProdukSelengkapnya(
                              kategori: KategoriProduk.buletin,
                            ),
                          ),
                        ));
                        Future.microtask(() async {
                          await viewModel.setKategori(KategoriProduk.buletin);
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
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 30),
              ),
            ],
            const SliverToBoxAdapter(
              child: SizedBox(height: 40),
            ),
          ],
        ],
      ),
    );
  }
}
