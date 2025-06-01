import 'package:flutter/material.dart';
import 'package:mediaexplant/core/constants/app_colors.dart';
import 'package:mediaexplant/core/utils/userID.dart';
import 'package:mediaexplant/features/home/presentation/logic/viewmodel/berita/berita_terbaru_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/logic/viewmodel/karya/desain_grafis_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/logic/viewmodel/karya/fotografi_viewmodel.dart';
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
  final Map<String, bool> _isLoading = {
    'berita': false,
    'majalah': false,
    'buletin': false,
    'puisi': false,
    'syair': false,
    'desain_grafis': false,
    'fotografi': false,
  };

  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInit) {
      _fetchKontenSecaraBerurutan();

      _isInit = false;
    }
  }

  Future<void> _fetchKontenSecaraBerurutan() async {
    final beritaVM =
        Provider.of<BeritaTerbaruViewmodel>(context, listen: false);
    final puisiVM = Provider.of<PuisiViewmodel>(context, listen: false);
    final syairVM = Provider.of<SyairViewmodel>(context, listen: false);
    final desainGrafisVM =
        Provider.of<DesainGrafisViewmodel>(context, listen: false);
    final fotografiVM = Provider.of<FotografiViewmodel>(context, listen: false);
    final majalahVM = Provider.of<MajalahViewmodel>(context, listen: false);
    final buletinVM = Provider.of<BuletinViewmodel>(context, listen: false);

    if (beritaVM.allBerita.isEmpty) {
      setState(() => _isLoading['berita'] = true);
      try {
        await beritaVM.refresh(userLogin);
      } catch (e) {
        debugPrint("Gagal fetch berita: $e");
      } finally {
        setState(() => _isLoading['berita'] = false);
      }
    }
    if (puisiVM.allKarya.isEmpty) {
      setState(() => _isLoading['puisi'] = true);
      try {
        await puisiVM.refresh(userLogin);
      } catch (e) {
        debugPrint("Gagal fetch puisi: $e");
      } finally {
        setState(() => _isLoading['puisi'] = false);
      }
    }
    if (syairVM.allKarya.isEmpty) {
      setState(() => _isLoading['syair'] = true);
      try {
        await syairVM.refresh(userLogin);
      } catch (e) {
        debugPrint("Gagal fetch syair: $e");
      } finally {
        setState(() => _isLoading['syair'] = false);
      }
    }
    if (desainGrafisVM.allKarya.isEmpty) {
      setState(() => _isLoading['desain_grafis'] = true);
      try {
        await desainGrafisVM.refresh(userLogin);
      } catch (e) {
        debugPrint("Gagal fetch desain grafis: $e");
      } finally {
        setState(() => _isLoading['desain_grafis'] = false);
      }
    }
    if (fotografiVM.allKarya.isEmpty) {
      setState(() => _isLoading['fotografi'] = true);
      try {
        await fotografiVM.refresh(userLogin);
      } catch (e) {
        debugPrint("Gagal fetch fotografi: $e");
      } finally {
        setState(() => _isLoading['fotografi'] = false);
      }
    }
    if (majalahVM.allMajalah.isEmpty) {
      setState(() => _isLoading['majalah'] = true);
      try {
        await majalahVM.refresh(userLogin);
      } catch (e) {
        debugPrint("Gagal fetch majalah: $e");
      } finally {
        setState(() => _isLoading['majalah'] = false);
      }
    }
    if (buletinVM.allBuletin.isEmpty) {
      setState(() => _isLoading['buletin'] = true);
      try {
        await buletinVM.refresh(userLogin);
      } catch (e) {
        debugPrint("Gagal fetch buletin: $e");
      } finally {
        setState(() => _isLoading['buletin'] = false);
      }
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
    final desainGrafisList =
        Provider.of<DesainGrafisViewmodel>(context).allKarya;
    final fotografiList = Provider.of<FotografiViewmodel>(context).allKarya;

    return RefreshIndicator(
      onRefresh: _fetchKontenSecaraBerurutan,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          const SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),

          // Berita loading atau list horizontal rekomendasi berita
          if (_isLoading['berita']!)
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => ShimmerBeritaItem(),
                childCount: 1,
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

          // Desain Grafis
          if (_isLoading['desain_grafis']!)
            const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator()))
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
