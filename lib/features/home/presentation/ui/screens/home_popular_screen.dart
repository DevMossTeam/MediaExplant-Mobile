import 'package:flutter/material.dart';
import 'package:mediaexplant/core/constants/app_colors.dart';
import 'package:mediaexplant/features/home/presentation/logic/berita_terkini_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita_mungkin_disukai.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita_populer_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita_terbaru_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita_terkini_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/komentar_terbanyak_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/tag_populer_item.dart';
import 'package:provider/provider.dart';

class HomePopularScreen extends StatefulWidget {
  const HomePopularScreen({super.key});

  @override
  State<HomePopularScreen> createState() => _HomePopularScreenState();
}

class _HomePopularScreenState extends State<HomePopularScreen> {
  bool _isLoading = false;
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final beritaProvider =
          Provider.of<BeritaTerkiniViewmodel>(context, listen: false);

      // Cek apakah data sudah pernah dimuat
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
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 10),
                //   child: ShaderMask(
                //     shaderCallback: (bounds) => const LinearGradient(
                //       colors: [
                //         AppColors.primary,
                //         Colors.red,
                //       ],
                //       begin: Alignment.topLeft,
                //       end: Alignment.bottomRight,
                //     ).createShader(bounds),
                //     child: const Text(
                //       "Berita Terpopuler",
                //       style: TextStyle(
                //         fontSize: 18,
                //         fontWeight: FontWeight.bold,
                //         color: Colors.white,
                //       ),
                //     ),
                //   ),
                // ),

                // berita paling baru

                // **Berita Terkini**
                if (beritaList.isNotEmpty)
                  ChangeNotifierProvider.value(
                    value: beritaList[0],
                    child: const BeritaTerkiniItem(),
                  ),

                // terpopuler 5 teratas
                const SizedBox(height: 10),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
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

                ListView.builder(
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
                const SizedBox(height: 10),

                Container(
                  color: Colors.grey.withAlpha(50),
                  child: Padding(
                    padding: EdgeInsets.only(left: 10, top: 20, bottom: 20),
                    child: Column(
                      children: [
                        const Row(
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

                // Dari Kami rekomendasi untuk anda
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
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

                // **Berita munkin disukai**
                const SizedBox(
                  height: 10,
                ),

                ListView.builder(
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

                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "Tag Terpopuler",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),

                SizedBox(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return TagPopulerItem(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Anda menekan tag ke-${index + 1}"),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "Komantar Terbanyak",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                ListView.builder(
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
              ],
            ),
          );
  }
}
