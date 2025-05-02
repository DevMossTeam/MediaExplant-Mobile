import 'package:flutter/material.dart';
import 'package:mediaexplant/core/constants/app_colors.dart';
import 'package:mediaexplant/features/home/presentation/logic/berita/berita_terbaru_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/logic/produk/majalah_view_model.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita/berita_rekomendasi_untuk_anda_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita/berita_teratas_untuk_anda.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/produk/majalah_item.dart';
import 'package:provider/provider.dart';

class HomeUntukAndaScreen extends StatefulWidget {
  const HomeUntukAndaScreen({super.key});

  @override
  State<HomeUntukAndaScreen> createState() => _HomeUntukAndaScreenState();
}

class _HomeUntukAndaScreenState extends State<HomeUntukAndaScreen> {
  var _isInit = true;
  Map<String, bool> _isLoading = {
    'berita': false,
    'majalah': false,
  };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInit) {
      final beritaVM =
          Provider.of<BeritaTerbaruViewmodel>(context, listen: false);
      final malajalahVM = Provider.of<MajalahViewModel>(context, listen: false);
      setState(() {
        _isLoading['berita'] = true;
        _isLoading['majalah'] = true;
      });

      Future.wait([
        beritaVM.fetchBeritaTerbaru("4FUD7QhJ0hMLMMlF6VQHjvkXad4L"),
        malajalahVM.fetchMajalah("4FUD7QhJ0hMLMMlF6VQHjvkXad4L"),
      ]).then((_) {
        setState(() {
          _isLoading['berita'] = false;
          _isLoading['majalah'] = false;
        });
      }).catchError((error) {
        print("Error fetch berita: $error");
        setState(() {
          _isLoading['berita'] = false;
          _isLoading['majalah'] = false;
        });
      });

      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final beritaList =
        Provider.of<BeritaTerbaruViewmodel>(context).allBerita;
    final majalahList =
        Provider.of<MajalahViewModel>(context).allMajalah;

    // Jika ada data yang sedang dimuat, tampilkan loading indicator
    if (_isLoading.values.contains(true)) {
      return const Center(child: CircularProgressIndicator());
    }
    return  SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: SizedBox(
                    height: 180,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 10,
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

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      Text(
                        "Berita",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Teratas untuk anda",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

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
                            itemCount: 10,
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
                            itemCount: 10,
                            itemBuilder: (contex, index) {
                              return ChangeNotifierProvider.value(
                                value: majalahList[index],
                                child: MajalahItem(),
                              );
                            }),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
