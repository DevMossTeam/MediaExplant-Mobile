import 'package:flutter/material.dart';
import 'package:mediaexplant/core/constants/app_colors.dart';
import 'package:mediaexplant/features/home/presentation/logic/berita_terkini_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita_mungkin_disukai.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita_populer_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita_rekomandasi_lain_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita_rekomendasi_untuk_anda_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita_terbaru_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita_terkini_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/komentar_terbanyak_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/tag_populer_item.dart';
import 'package:provider/provider.dart';

class HomeBeritaScreen extends StatefulWidget {
  const HomeBeritaScreen({super.key});

  @override
  State<HomeBeritaScreen> createState() => _HomeBeritaScreenState();
}

class _HomeBeritaScreenState extends State<HomeBeritaScreen> {
  bool _isLoading = false;
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final beritaProvider =
          Provider.of<BeritaTerkiniViewmodel>(context, listen: false);

      // // Cek apakah data sudah pernah dimuat
      if (!beritaProvider.isLoaded) {
        setState(() {
          _isLoading = true;
        });

        beritaProvider.getBerita().then((_) {
          setState(() {
            _isLoading = false;
          });
        }).catchError((error) {
          print("Error saat get berita: $error");
          setState(() {
            _isLoading = false;
          });
        });
      }

      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final beritaProvider = Provider.of<BeritaTerkiniViewmodel>(context);
    final beritaList = beritaProvider.allBerita;
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),

                // Dengan ini
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return ChangeNotifierProvider.value(
                      value: beritaList[index],
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
                              value: beritaList[index],
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
                        Container(
                          height: 150,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: beritaList.length,
                            itemBuilder: (context, index) {
                              return ChangeNotifierProvider.value(
                                value: beritaList[index],
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
                    itemCount: beritaList.length,
                    itemBuilder: (context, index) {
                      return ChangeNotifierProvider.value(
                        value: beritaList[index],
                        child: BeritaMungkinDisukai(),
                      );
                    },
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.only(left: 15, top: 20),
                  child: Row(
                    children: [
                      Text(
                        "Tag Terpopuler",
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

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: SizedBox(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return TagPopulerItem(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text("Anda menekan tag ke-${index + 1}"),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 15, top: 20),
                  child: Row(
                    children: [
                      Text(
                        "Komentar Terbanyak",
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ListView.builder(
                    // Menyesuaikan ukuran dengan isi list
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return ChangeNotifierProvider.value(
                          value: beritaList[index],
                          child: KomentarTerbanyakItem());
                    },
                  ),
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
                            itemCount: beritaList.length,
                            itemBuilder: (context, index) {
                              return ChangeNotifierProvider.value(
                                value: beritaList[index],
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
