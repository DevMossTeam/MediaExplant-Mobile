import 'package:flutter/material.dart';
import 'package:mediaexplant/core/constants/app_colors.dart';
import 'package:mediaexplant/core/utils/userID.dart';
import 'package:mediaexplant/features/home/presentation/logic/viewmodel/berita/berita_terbaru_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/logic/viewmodel/karya/desain_grafis_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/logic/viewmodel/karya/fotografi_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/logic/viewmodel/karya/puisi_terbaru_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/logic/viewmodel/karya/syair_terbaru_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/logic/viewmodel/produk/produk_view_model.dart';
import 'package:mediaexplant/features/home/presentation/ui/screens/home_screen.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita/berita_rekomendasi_untuk_anda_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita/berita_teratas_untuk_anda.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita/shimmer_berita.item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/karya/desain_grafis_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/karya/fotografi_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/karya/puisi_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/produk/produk_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/title_header_widget.dart';
import 'package:mediaexplant/main.dart';
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
    final puisiVM = Provider.of<PuisiTerbaruViewmodel>(context, listen: false);
    final syairVM = Provider.of<SyairTerbaruViewmodel>(context, listen: false);
    final desainGrafisVM =
        Provider.of<DesainGrafisViewmodel>(context, listen: false);
    final fotografiVM = Provider.of<FotografiViewmodel>(context, listen: false);
    final produkVM = Provider.of<ProdukViewModel>(context, listen: false);

    // Fetch berita
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

    // Fetch puisi
    if (puisiVM.allPuisi.isEmpty) {
      setState(() => _isLoading['puisi'] = true);
      try {
        await puisiVM.fetchPuisiTerbaru(userLogin);
      } catch (e) {
        debugPrint("Gagal fetch puisi: $e");
      } finally {
        setState(() => _isLoading['puisi'] = false);
      }
    }

    // Fetch syair
    if (syairVM.allSyair.isEmpty) {
      setState(() => _isLoading['syair'] = true);
      try {
        await syairVM.fetchSyairTerbaru(userLogin);
      } catch (e) {
        debugPrint("Gagal fetch syair: $e");
      } finally {
        setState(() => _isLoading['syair'] = false);
      }
    }

    // Fetch desain grafis
    if (desainGrafisVM.allDesainGrafis.isEmpty) {
      setState(() => _isLoading['desain_grafis'] = true);
      try {
        await desainGrafisVM.fetchDesainGrafis(userLogin);
      } catch (e) {
        debugPrint("Gagal fetch desain grafis: $e");
      } finally {
        setState(() => _isLoading['desain_grafis'] = false);
      }
    }

    // Fetch fotografi
    if (fotografiVM.allFotografi.isEmpty) {
      setState(() => _isLoading['fotografi'] = true);
      try {
        await fotografiVM.fetchFotografi(userLogin);
      } catch (e) {
        debugPrint("Gagal fetch fotografi: $e");
      } finally {
        setState(() => _isLoading['fotografi'] = false);
      }
    }

    // Fetch majalah
    if (produkVM.allMajalah.isEmpty) {
      setState(() => _isLoading['majalah'] = true);
      try {
        await produkVM.fetchMajalah(userLogin);
      } catch (e) {
        debugPrint("Gagal fetch majalah: $e");
      } finally {
        setState(() => _isLoading['majalah'] = false);
      }
    }

    // Fetch buletin
    if (produkVM.allBuletin.isEmpty) {
      setState(() => _isLoading['buletin'] = true);
      try {
        await produkVM.fetchBuletin(userLogin);
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
    final majalahList = Provider.of<ProdukViewModel>(context).allMajalah;
    final buletinList = Provider.of<ProdukViewModel>(context).allBuletin;
    final puisiList = Provider.of<PuisiTerbaruViewmodel>(context).allPuisi;
    final syairList = Provider.of<SyairTerbaruViewmodel>(context).allSyair;
    final desainGrafisList =
        Provider.of<DesainGrafisViewmodel>(context).allDesainGrafis;
    final fotografiList = Provider.of<FotografiViewmodel>(context).allFotografi;

    // // Jika ada data yang sedang dimuat, tampilkan loading indicator
    // if (_isLoading.values.contains(true)) {
    //   return const Center(child: CircularProgressIndicator());
    // }
    return RefreshIndicator(
      onRefresh: _fetchKontenSecaraBerurutan,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            if (_isLoading['berita']!)
              // const Center(child: CircularProgressIndicator())
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 1,
                itemBuilder: (context, index) {
                  return ShimmerBeritaItem();
                },
              )
            else ...[
              Padding(
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
              const SizedBox(
                height: 20,
              ),
              Container(
                color: Colors.grey.withAlpha(50),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, top: 20, bottom: 20),
                  child: Column(
                    children: [
                      titleHeader("Berita", "Teratas untuk anda"),
                      const SizedBox(
                        height: 20,
                      ),
                      // berita terbaru
                      SizedBox(
                        height: 200,
                        child: GridView.builder(
                            itemCount: beritaList.length.clamp(0, 10),
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
                                value: beritaList[index],
                                child: BeritaTeratasUntukAnda(),
                              );
                            }),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              // aksi saat tombol ditekan
                              print("Tombol ditekan");
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
              // Padding(
              //   padding: const EdgeInsets.only(
              //     left: 15,
              //     top: 10,
              //   ),
              //   child: Column(
              //     children: [
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.end,
              //         children: [
              //           TextButton(
              //             onPressed: () {
              //               // aksi saat tombol ditekan
              //               print("Tombol ditekan");
              //             },
              //             child: const Text(
              //               "Selengkapnya >>",
              //               style: TextStyle(
              //                 color: AppColors.primary,
              //                 fontSize: 14,
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ],
              //   ),
              // ),
            ],
            Padding(
              padding: const EdgeInsets.only(
                left: 15,
                top: 10,
              ),
              child: Column(
                children: [
                  if (_isLoading['puisi']!)
                    const Center(child: CircularProgressIndicator())
                  else ...[
                    titleHeader("Puisi", "Terbaru untuk anda"),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 240,
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: puisiList.length.clamp(0, 5),
                          itemBuilder: (contex, index) {
                            return ChangeNotifierProvider.value(
                              value: puisiList[index],
                              child: PuisiItem(),
                            );
                          }),
                    ),
                  ],
                  const SizedBox(
                    height: 10,
                  ),
                  if (_isLoading['syair']!)
                    const Center(child: CircularProgressIndicator())
                  else ...[
                    titleHeader("Syair", "Terbaru untuk anda"),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 240,
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: syairList.length.clamp(0, 5),
                          itemBuilder: (contex, index) {
                            return ChangeNotifierProvider.value(
                              value: syairList[index],
                              child: PuisiItem(),
                            );
                          }),
                    ),
                  ],
                  const SizedBox(
                    height: 10,
                  ),
                  if (_isLoading['desain_grafis']!)
                    const Center(child: CircularProgressIndicator())
                  else ...[
                    titleHeader("Desain Grafis", "Terbaru untuk anda"),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: desainGrafisList.length.clamp(0, 5),
                          itemBuilder: (contex, index) {
                            return ChangeNotifierProvider.value(
                              value: desainGrafisList[index],
                              child: DesainGrafisItem(),
                            );
                          }),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            if (_isLoading['fotografi']!)
              const Center(child: CircularProgressIndicator())
            else ...[
              Container(
                color: Colors.grey.withAlpha(50),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, top: 20, bottom: 20),
                  child: Column(
                    children: [
                      // berita terbaru
                      titleHeader("Fotografi", "Terbaru untuk anda"),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 200,
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
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.end,
                      //   children: [
                      //     TextButton(
                      //       onPressed: () {
                      //         // aksi saat tombol ditekan
                      //         print("Tombol ditekan");
                      //       },
                      //       child: const Text(
                      //         "Selengkapnya >>",
                      //         style: TextStyle(
                      //           color: AppColors.primary,
                      //           fontSize: 14,
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(
              height: 10,
            ),
            if (_isLoading['majalah']!)
              const Center(child: CircularProgressIndicator())
            else
              ...[],
            Padding(
              padding: const EdgeInsets.only(
                left: 15,
                top: 10,
              ),
              child: Column(
                children: [
                  if (_isLoading['majalah']!)
                    const Center(child: CircularProgressIndicator())
                  else ...[
                    titleHeader("Majalah", "Terbaru untuk anda"),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 240,
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: majalahList.length.clamp(0, 5),
                          itemBuilder: (contex, index) {
                            return ChangeNotifierProvider.value(
                              value: majalahList[index],
                              child: ProdukItem(),
                            );
                          }),
                    ),
                  ],
                  const SizedBox(
                    height: 10,
                  ),
                  if (_isLoading['majalah']!)
                    const Center(child: CircularProgressIndicator())
                  else ...[
                    titleHeader("Buletin", "Terbaru untuk anda"),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 240,
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: buletinList.length.clamp(0, 5),
                          itemBuilder: (contex, index) {
                            return ChangeNotifierProvider.value(
                              value: buletinList[index],
                              child: ProdukItem(),
                            );
                          }),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
