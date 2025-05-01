import 'package:flutter/material.dart';
import 'package:mediaexplant/core/constants/app_colors.dart';
import 'package:mediaexplant/features/home/presentation/logic/berita/berita_populer_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/logic/berita/berita_dari_kami_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/logic/berita/berita_rekomendasi_lain_view_model.dart';
import 'package:mediaexplant/features/home/presentation/logic/berita/berita_terbaru_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita/berita_dari_kami.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita/berita_populer_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita/berita_rekomandasi_lain_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita/berita_terbaru_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita/berita_terkini_item.dart';
import 'package:provider/provider.dart';

class HomeBeritaScreen extends StatefulWidget {
  const HomeBeritaScreen({super.key});

  @override
  State<HomeBeritaScreen> createState() => _HomeBeritaScreenState();
}

class _HomeBeritaScreenState extends State<HomeBeritaScreen> {
  var _isInit = true;
  Map<String, bool> _isLoading = {
    'terkini': false,
    'populer': false,
    'rekomendasi': false,
    'rekomendasiLain': false,
  };

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
        beritaRekomendasiLainVM
            .fetchBeritaRekomendasiLain("4FUD7QhJ0hMLMMlF6VQHjvkXad4L"),
      ]).then((_) {
        setState(() {
          _isLoading['terkini'] = false;
          _isLoading['populer'] = false;
          _isLoading['rekomendasi'] = false;
          _isLoading['rekomendasiLain'] = false;
        });
      }).catchError((error) {
        print("Error fetch berita: $error");
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
            physics: NeverScrollableScrollPhysics(),
            itemCount: 1,
            itemBuilder: (context, index) {
              return ChangeNotifierProvider.value(
                value: beritaTerkiniList[index],
                child: const BeritaTerkiniItem(),
              );
            },
          ),

          // terpopuler 5 teratas
          const SizedBox(height: 20),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Text(
                  "Terpopuler",
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
                  "5 Teratas untuk anda",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
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
              padding: EdgeInsets.only(left: 15, top: 20, bottom: 20),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Text(
                        "Terbaru",
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
                  const SizedBox(
                    height: 20,
                  ),

                  // berita terbaru
                  Container(
                    height: 180,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: beritaTerkiniList.length,
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
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Text(
                  "Dari Kami",
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
                  "Mungkin anda suka",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: beritaRekomendasiList.length,
              itemBuilder: (context, index) {
                return ChangeNotifierProvider.value(
                  value: beritaRekomendasiList[index],
                  child: BeritaDariKami(),
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

          // const Padding(
          //   padding: EdgeInsets.only(left: 15, top: 20),
          //   child: Row(
          //     children: [
          //       Text(
          //         "Tag Terpopuler",
          //         style: TextStyle(
          //           fontSize: 16,
          //           fontWeight: FontWeight.bold,
          //           color: Colors.black,
          //         ),
          //       ),
          //       SizedBox(
          //         width: 10,
          //       ),
          //       Text(
          //         "5 Teratas untuk anda",
          //         style: TextStyle(
          //           fontSize: 12,
          //           color: Colors.grey,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),

          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 5),
          //   child: SizedBox(
          //     child: ListView.builder(
          //       shrinkWrap: true,
          //       physics: const NeverScrollableScrollPhysics(),
          //       itemCount: 5,
          //       itemBuilder: (context, index) {
          //         return TagPopulerItem(
          //           onTap: () {
          //             ScaffoldMessenger.of(context).showSnackBar(
          //               SnackBar(
          //                 content:
          //                     Text("Anda menekan tag ke-${index + 1}"),
          //                 duration: const Duration(seconds: 2),
          //               ),
          //             );
          //           },
          //         );
          //       },
          //     ),
          //   ),
          // ),
          // const Padding(
          //   padding: EdgeInsets.only(left: 15, top: 20),
          //   child: Row(
          //     children: [
          //       Text(
          //         "Komentar Terbanyak",
          //         style: TextStyle(
          //           fontSize: 16,
          //           fontWeight: FontWeight.bold,
          //           color: Colors.black,
          //         ),
          //       ),
          //       SizedBox(
          //         width: 10,
          //       ),
          //       Text(
          //         "5 Teratas untuk anda",
          //         style: TextStyle(
          //           fontSize: 12,
          //           color: Colors.grey,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 8),
          //   child: ListView.builder(
          //     // Menyesuaikan ukuran dengan isi list
          //     shrinkWrap: true,
          //     physics: const NeverScrollableScrollPhysics(),
          //     itemCount: 5,
          //     itemBuilder: (context, index) {
          //       return ChangeNotifierProvider.value(
          //           value: beritaPopulerList[index],
          //           child: KomentarTerbanyakItem());
          //     },
          //   ),
          // ),

          const SizedBox(
            height: 20,
          ),

          // berita rekomandasi lainnya
          Container(
            color: Colors.grey.withAlpha(50),
            child: Padding(
              padding: EdgeInsets.only(left: 15, top: 20, bottom: 20),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Text(
                        "Rekomendasi Lain",
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
                        "mungkin anda suka",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
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
        ],
      ),
    );
  }
}
