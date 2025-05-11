import 'package:flutter/material.dart';
import 'package:mediaexplant/core/constants/app_colors.dart';
import 'package:mediaexplant/features/home/presentation/logic/berita/berita_populer_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/logic/berita/berita_dari_kami_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/logic/berita/berita_rekomendasi_lain_view_model.dart';
import 'package:mediaexplant/features/home/presentation/logic/berita/berita_terbaru_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita/berita_populer_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita/berita_rekomandasi_lain_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita/berita_terbaru_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita/berita_terkini_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/title_header_widget.dart';
import 'package:provider/provider.dart';

class HomeBeritaScreen extends StatefulWidget {
  const HomeBeritaScreen({super.key});

  @override
  State<HomeBeritaScreen> createState() => _HomeBeritaScreenState();
}

class _HomeBeritaScreenState extends State<HomeBeritaScreen>
    with AutomaticKeepAliveClientMixin<HomeBeritaScreen> {
  var _isInit = true;
  final Map<String, bool> _isLoading = {
    'terkini': false,
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
      final beritaTerkiniVM =
          Provider.of<BeritaTerbaruViewmodel>(context, listen: false);
      final beritaPopulerVM =
          Provider.of<BeritaPopulerViewmodel>(context, listen: false);
      final beritaRekomendasiVM =
          Provider.of<BeritaDariKamiViewmodel>(context, listen: false);
      final beritaRekomendasiLainVM =
          Provider.of<BeritaRekomendasiLainViewModel>(context, listen: false);

      setState(() {
        _isLoading['terkini'] = true;
        _isLoading['populer'] = true;
        _isLoading['rekomendasi'] = true;
        _isLoading['rekomendasiLain'] = true;
      });

      Future.wait([
        beritaTerkiniVM.fetchBeritaTerbaru("4FUD7QhJ0hMLMMlF6VQHjvkXad4L"),
        beritaPopulerVM.fetchBeritaPopuler("4FUD7QhJ0hMLMMlF6VQHjvkXad4L"),
        beritaRekomendasiVM.fetchBeritaDariKami("4FUD7QhJ0hMLMMlF6VQHjvkXad4L"),
        beritaRekomendasiLainVM.fetchBeritaRekomendasiLain("4FUD7QhJ0hMLMMlF6VQHjvkXad4L"),
      ]).then((_) {
        setState(() {
          _isLoading['terkini'] = false;
          _isLoading['populer'] = false;
          _isLoading['rekomendasi'] = false;
          _isLoading['rekomendasiLain'] = false;
        });
      }).catchError((error) {
        setState(() {
          _isLoading['terkini'] = false;
          _isLoading['populer'] = false;
          _isLoading['rekomendasi'] = false;
          _isLoading['rekomendasiLain'] = false;
        });
      });

      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final beritaTerkiniList =
        Provider.of<BeritaTerbaruViewmodel>(context).allBerita;
    final beritaPopulerList =
        Provider.of<BeritaPopulerViewmodel>(context).allBerita;
    final beritaRekomendasiList =
        Provider.of<BeritaDariKamiViewmodel>(context).allBerita;
    final beritaRekomendasiLainList =
        Provider.of<BeritaRekomendasiLainViewModel>(context).allBerita;

    // Jika ada data yang sedang dimuat, tampilkan loading indicator
    if (_isLoading.values.contains(true)) {
      return const Center(child: CircularProgressIndicator());
    }
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),

          // Berita terkini
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 1,
            itemBuilder: (context, index) {
              return ChangeNotifierProvider.value(
                value: beritaTerkiniList[index],
                child: BeritaTerkiniItem(),
              );
            },
          ),

          // terpopuler 5 teratas
          const SizedBox(height: 20),

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
              itemCount: 5,
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
          const SizedBox(height: 10),

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
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return ChangeNotifierProvider.value(
                          value: beritaTerkiniList[index],
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

          const SizedBox(
            height: 20,
          ),
          // Dari Kami mungkin anda suka
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
              itemCount: 10,
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
            height: 20,
          ),

          // berita rekomandasi lainnya
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
                      itemCount: 10,
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
                        onPressed: () {
                          // aksi saat tombol ditekan
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
      ),
    );
  }
}
