import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:mediaexplant/core/constants/app_colors.dart';
import 'package:mediaexplant/core/utils/userID.dart';
import 'package:mediaexplant/features/home/presentation/logic/viewmodel/karya/desain_grafis_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/logic/viewmodel/karya/fotografi_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/logic/viewmodel/karya/pantun_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/logic/viewmodel/karya/puisi_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/logic/viewmodel/karya/syair_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/ui/screens/karya_selengkapnya.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/karya/desain_grafis_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/karya/fotografi_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/karya/puisi_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/title_header_widget.dart';
import 'package:provider/provider.dart';

class HomeKaryaScreen extends StatefulWidget {
  const HomeKaryaScreen({super.key});

  @override
  State<HomeKaryaScreen> createState() => _HomeKaryaScreenState();
}

class _HomeKaryaScreenState extends State<HomeKaryaScreen>
    with AutomaticKeepAliveClientMixin<HomeKaryaScreen> {
  var _isInit = true;
  bool _isOffline = false;
  final Map<String, bool> _isLoading = {
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
      _fetchKaryaSecaraBerurutan();
      _isInit = false;
    }
  }

  Future<void> _checkConnection() async {
    final result = await Connectivity().checkConnectivity();
    setState(() => _isOffline = result == ConnectivityResult.none);
  }

  Future<void> _fetchKaryaSecaraBerurutan() async {
    final vmPuisi = Provider.of<PuisiViewmodel>(context, listen: false);
    final vmSyair = Provider.of<SyairViewmodel>(context, listen: false);
    final vmPantun = Provider.of<PantunViewmodel>(context, listen: false);
    final vmDG = Provider.of<DesainGrafisViewmodel>(context, listen: false);
    final vmFoto = Provider.of<FotografiViewmodel>(context, listen: false);

    try {
      setState(() => _isLoading['puisi'] = true);
      await vmPuisi.refresh(userLogin);
      setState(() => _isLoading['puisi'] = false);

      setState(() => _isLoading['syair'] = true);
      await vmSyair.refresh(userLogin);
      setState(() => _isLoading['syair'] = false);

      setState(() => _isLoading['pantun'] = true);
      await vmPantun.refresh(userLogin);
      setState(() => _isLoading['pantun'] = false);

      setState(() => _isLoading['desain_grafis'] = true);
      await vmDG.refresh(userLogin);
      setState(() => _isLoading['desain_grafis'] = false);

      setState(() => _isLoading['fotografi'] = true);
      await vmFoto.refresh(userLogin);
      setState(() => _isLoading['fotografi'] = false);
    } catch (e) {
      debugPrint('Error saat refresh: $e');
    }
  }

  Widget buildKategoriSection<T>({
    required String judul,
    required bool isLoading,
    required bool isOffline,
    required List<T> listData,
    required IndexedWidgetBuilder itemBuilder,
    required VoidCallback onMore,
    double listHeight = 240,
    bool isGrid = false,
    SliverGridDelegate? gridDelegate,
  }) {
    if (isLoading) {
      return const SliverToBoxAdapter(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    // if (listData.isEmpty) {
    //   return SliverToBoxAdapter(
    //     child: Center(
    //       child: Text(
    //         isOffline ? 'Tidak ada koneksi internet.' : 'Gagal memuat $judul.',
    //         style: const TextStyle(fontSize: 16, color: Colors.grey),
    //       ),
    //     ),
    //   );
    // }

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleHeader(judul, "Dari yang terbaru"),
          const SizedBox(height: 10),
          SizedBox(
            height: listHeight,
            child: isGrid
                ? GridView.builder(
                    scrollDirection: Axis.horizontal,
                    gridDelegate: gridDelegate!,
                    itemCount: listData.length.clamp(0, 10),
                    itemBuilder: itemBuilder,
                  )
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: listData.length.clamp(0, 5),
                    itemBuilder: itemBuilder,
                  ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: onMore,
              child: const Text(
                "Selengkapnya >>",
                style: TextStyle(color: AppColors.primary, fontSize: 14),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final puisi = Provider.of<PuisiViewmodel>(context).allKarya;
    final syair = Provider.of<SyairViewmodel>(context).allKarya;
    final pantun = Provider.of<PantunViewmodel>(context).allKarya;
    final dg = Provider.of<DesainGrafisViewmodel>(context).allKarya;
    final foto = Provider.of<FotografiViewmodel>(context).allKarya;

    return RefreshIndicator(
      onRefresh: _fetchKaryaSecaraBerurutan,
      child: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            sliver: buildKategoriSection(
              judul: "Puisi",
              isLoading: _isLoading['puisi']!,
              isOffline: _isOffline,
              listData: puisi,
              itemBuilder: (c, i) => ChangeNotifierProvider.value(
                value: puisi[i],
                child: PuisiItem(),
              ),
              onMore: () {
                final vm = KaryaSelengkapnyaViewModel();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => ChangeNotifierProvider.value(
                      value: vm,
                      child: const KaryaSelengkapnya(
                        kategori: KategoriKarya.puisi,
                      ),
                    ),
                  ),
                );
                Future.microtask(() => vm.setKategori(KategoriKarya.puisi));
              },
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            sliver: buildKategoriSection(
              judul: "Syair",
              isLoading: _isLoading['syair']!,
              isOffline: _isOffline,
              listData: syair,
              itemBuilder: (c, i) => ChangeNotifierProvider.value(
                value: syair[i],
                child: PuisiItem(),
              ),
              onMore: () {
                final vm = KaryaSelengkapnyaViewModel();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => ChangeNotifierProvider.value(
                      value: vm,
                      child: const KaryaSelengkapnya(
                        kategori: KategoriKarya.syair,
                      ),
                    ),
                  ),
                );
                Future.microtask(() => vm.setKategori(KategoriKarya.syair));
              },
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            sliver: buildKategoriSection(
              judul: "Pantun",
              isLoading: _isLoading['pantun']!,
              isOffline: _isOffline,
              listData: pantun,
              itemBuilder: (c, i) => ChangeNotifierProvider.value(
                value: pantun[i],
                child: PuisiItem(),
              ),
              onMore: () {
                final vm = KaryaSelengkapnyaViewModel();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => ChangeNotifierProvider.value(
                      value: vm,
                      child: const KaryaSelengkapnya(
                        kategori: KategoriKarya.pantun,
                      ),
                    ),
                  ),
                );
                Future.microtask(() => vm.setKategori(KategoriKarya.pantun));
              },
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            sliver: buildKategoriSection(
              judul: "Desain Grafis",
              isLoading: _isLoading['desain_grafis']!,
              isOffline: _isOffline,
              listData: dg,
              itemBuilder: (c, i) => ChangeNotifierProvider.value(
                value: dg[i],
                child: DesainGrafisItem(),
              ),
              onMore: () {
                final vm = KaryaSelengkapnyaViewModel();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => ChangeNotifierProvider.value(
                      value: vm,
                      child: const KaryaSelengkapnya(
                        kategori: KategoriKarya.desainGrafis,
                      ),
                    ),
                  ),
                );
                Future.microtask(
                    () => vm.setKategori(KategoriKarya.desainGrafis));
              },
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            sliver: buildKategoriSection(
              judul: "Fotografi",
              isLoading: _isLoading['fotografi']!,
              isOffline: _isOffline,
              listData: foto,
              itemBuilder: (c, i) => ChangeNotifierProvider.value(
                value: foto[i],
                child: FotografiItem(),
              ),
              onMore: () {
                final vm = KaryaSelengkapnyaViewModel();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => ChangeNotifierProvider.value(
                      value: vm,
                      child: const KaryaSelengkapnya(
                        kategori: KategoriKarya.fotografi,
                      ),
                    ),
                  ),
                );
                Future.microtask(() => vm.setKategori(KategoriKarya.fotografi));
              },
              listHeight: 200,
              isGrid: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.27,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }
}
