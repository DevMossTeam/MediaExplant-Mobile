import 'package:flutter/material.dart';
import 'package:mediaexplant/core/constants/app_colors.dart';
import 'package:mediaexplant/features/home/presentation/logic/berita/berita_terbaru_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/logic/karya/desain_grafis_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/logic/karya/puisi_terbaru_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/logic/karya/syair_terbaru_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/logic/produk/produk_view_model.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita/berita_rekomendasi_untuk_anda_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita/berita_teratas_untuk_anda.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/karya/desain_grafis_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/karya/puisi_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/produk/produk_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/title_header_widget.dart';
import 'package:provider/provider.dart';

class HomeUntukAndaScreen extends StatefulWidget {
  const HomeUntukAndaScreen({super.key});

  @override
  State<HomeUntukAndaScreen> createState() => _HomeUntukAndaScreenState();
}

class _HomeUntukAndaScreenState extends State<HomeUntukAndaScreen> {
  var _isInit = true;
  final Map<String, bool> _isLoading = {
    'berita': false,
    'produk': false,
    'puisi': false,
    'syair': false,
    'desain_grafis': false,
  };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInit) {
      final beritaVM =
          Provider.of<BeritaTerbaruViewmodel>(context, listen: false);
      final produkVM = Provider.of<ProdukViewModel>(context, listen: false);
      final puisiVM =
          Provider.of<PuisiTerbaruViewmodel>(context, listen: false);
      final syairVM =
          Provider.of<SyairTerbaruViewmodel>(context, listen: false);
      final desainGrafisVM =
          Provider.of<DesainGrafisViewmodel>(context, listen: false);
      setState(() {
        _isLoading['berita'] = true;
        _isLoading['produk'] = true;
        _isLoading['puisi'] = true;
        _isLoading['syair'] = true;
        _isLoading['desain_grafis'] = true;
      });

      Future.wait([
        beritaVM.fetchBeritaTerbaru("4FUD7QhJ0hMLMMlF6VQHjvkXad4L"),
        produkVM.fetchMajalah("4FUD7QhJ0hMLMMlF6VQHjvkXad4L"),
        produkVM.fetchBuletin("4FUD7QhJ0hMLMMlF6VQHjvkXad4L"),
        puisiVM.fetchPuisiTerbaru("4FUD7QhJ0hMLMMlF6VQHjvkXad4L"),
        syairVM.fetchSyairTerbaru("4FUD7QhJ0hMLMMlF6VQHjvkXad4L"),
        desainGrafisVM.fetchDesainGrafis("4FUD7QhJ0hMLMMlF6VQHjvkXad4L"),
      ]).then((_) {
        setState(() {
          _isLoading['berita'] = false;
          _isLoading['produk'] = false;
          _isLoading['puisi'] = false;
          _isLoading['syair'] = false;
          _isLoading['desain_grafis'] = false;
        });
      }).catchError((error) {
        print("Error fetch berita: $error");
        setState(() {
          _isLoading['berita'] = false;
          _isLoading['produk'] = false;
          _isLoading['puisi'] = false;
          _isLoading['syair'] = false;
          _isLoading['desain_grafis'] = false;
        });
      });

      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final beritaList = Provider.of<BeritaTerbaruViewmodel>(context).allBerita;
    final majalahList = Provider.of<ProdukViewModel>(context).allMajalah;
    final buletinList = Provider.of<ProdukViewModel>(context).allBuletin;
    final puisiList = Provider.of<PuisiTerbaruViewmodel>(context).allPuisi;
    final syairList = Provider.of<SyairTerbaruViewmodel>(context).allSyair;
    final desainGrafisList =
        Provider.of<DesainGrafisViewmodel>(context).allDesainGrafis;

    // Jika ada data yang sedang dimuat, tampilkan loading indicator
    if (_isLoading.values.contains(true)) {
      return const Center(child: CircularProgressIndicator());
    }
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),

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

          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: titleHeader("Terpopuler", "5 Teratas untuk anda")),

          // berita teratas untuk anda

          Padding(
            padding: const EdgeInsets.only(
              left: 15,
              top: 10,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 170,
                  child: GridView.builder(
                      itemCount: beritaList.length.clamp(0, 10),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 0.25,
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
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 250,
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
                SizedBox(
                  height: 250,
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
                SizedBox(
                  height: 250,
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
                SizedBox(
                  height: 250,
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
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 250,
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
            ),
          ),
        ],
      ),
    );
  }
}
