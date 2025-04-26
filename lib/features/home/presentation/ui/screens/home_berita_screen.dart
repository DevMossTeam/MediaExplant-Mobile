import 'package:flutter/material.dart';
import 'package:mediaexplant/core/constants/app_colors.dart';
import 'package:mediaexplant/features/home/presentation/logic/berita_populer_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/logic/berita_dari_kami_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/logic/berita_rekomendasi_lain_view_model.dart';
import 'package:mediaexplant/features/home/presentation/logic/berita_terkini_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita/berita_dari_kami.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita/berita_populer_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita/berita_rekomandasi_lain_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita/berita_terbaru_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita/berita_terkini_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita/komentar_terbanyak_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita/tag_populer_item.dart';
import 'package:provider/provider.dart';

class HomeBeritaScreen extends StatefulWidget {
  const HomeBeritaScreen({super.key});

  @override
  State<HomeBeritaScreen> createState() => _HomeBeritaScreenState();
}

class _HomeBeritaScreenState extends State<HomeBeritaScreen> {
  var _isInit = true;
  var _isLoadingTerkini = false;
  var _isLoadingPopuler = false;
  var _isLoadingRekomendasi = false;
  var _isLoadingRekomendasiLain = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInit) {
      final beritaTerkiniVM =
          Provider.of<BeritaTerkiniViewmodel>(context, listen: false);
      final beritaPopulerVM =
          Provider.of<BeritaPopulerViewmodel>(context, listen: false);
      final beritaRekomendasiVM =
          Provider.of<BeritaDariKamiViewmodel>(context, listen: false);
      final beritaRekomendasiLainVM =
          Provider.of<BeritaRekomendasiLainViewModel>(context, listen: false);

      setState(() {
        _isLoadingTerkini = true;
        _isLoadingPopuler = true;
        _isLoadingRekomendasi = true;
        _isLoadingRekomendasiLain = true;
      });

      Future.wait([
        beritaTerkiniVM.fetchBeritaTerkini("4FUD7QhJ0hMLMMlF6VQHjvkXad4L"),
        beritaPopulerVM.fetchBeritaTerkini("4FUD7QhJ0hMLMMlF6VQHjvkXad4L"),
        beritaRekomendasiVM.fetchBeritaTerkini("4FUD7QhJ0hMLMMlF6VQHjvkXad4L"),
        beritaRekomendasiLainVM
            .fetchBeritaTerkini("4FUD7QhJ0hMLMMlF6VQHjvkXad4L"),
      ]).then((_) {
        setState(() {
          _isLoadingTerkini = false;
          _isLoadingPopuler = false;
          _isLoadingRekomendasi = false;
          _isLoadingRekomendasiLain = false;
        });
      }).catchError((error) {
        print("Error fetch berita: $error");
        setState(() {
          _isLoadingTerkini = false;
          _isLoadingPopuler = false;
          _isLoadingRekomendasi = false;
          _isLoadingRekomendasiLain = false;
        });
      });

      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final beritaTerkiniList =
        Provider.of<BeritaTerkiniViewmodel>(context).allBerita;
    final beritaPopulerList =
        Provider.of<BeritaPopulerViewmodel>(context).allBerita;
    final beritaRekomendasiList =
        Provider.of<BeritaDariKamiViewmodel>(context).allBerita;
    final beritaRekomendasiLainList =
        Provider.of<BeritaRekomendasiLainViewModel>(context).allBerita;
    return _isLoadingTerkini || _isLoadingPopuler || _isLoadingRekomendasi
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
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
                const SizedBox(height: 10),

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
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: AppColors.primary.withAlpha(50),
                            ),
                            margin: const EdgeInsets.only(left: 10),
                            width: 25,
                            height: 60,
                            alignment: Alignment.center,
                            child: Text(
                              "${index + 1}",
                              style: TextStyle(
                                color: AppColors.primary.withAlpha(100),
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
                          height: 150,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: beritaPopulerList.length,
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
                    itemCount: beritaPopulerList.length,
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
