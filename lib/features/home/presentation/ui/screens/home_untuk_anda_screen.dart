import 'package:flutter/material.dart';
import 'package:mediaexplant/core/constants/app_colors.dart';
import 'package:mediaexplant/features/home/presentation/logic/berita_terkini_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita_rekomendasi_untuk_anda_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita_teratas_untuk_anda.dart';
import 'package:provider/provider.dart';

class HomeUntukAndaScreen extends StatefulWidget {
  const HomeUntukAndaScreen({super.key});

  @override
  State<HomeUntukAndaScreen> createState() => _HomeUntukAndaScreenState();
}

class _HomeUntukAndaScreenState extends State<HomeUntukAndaScreen> {
  bool _isLoading = false;
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final beritaProvider =
          Provider.of<BeritaTerkiniViewmodel>(context, listen: false);

      // // Cek apakah data sudah pernah dimuat
      // if (!beritaProvider.isLoaded) {
      //   setState(() {
      //     _isLoading = true;
      //   });

      //   beritaProvider.getBerita().then((_) {
      //     setState(() {
      //       _isLoading = false;
      //     });
      //   }).catchError((error) {
      //     print("Error saat get berita: $error");
      //     setState(() {
      //       _isLoading = false;
      //     });
      //   });
      // }

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
                const SizedBox(height: 20),

                Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: SizedBox(
                    height: 180,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: beritaList.length,
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
                    top: 5,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 140,
                        child: GridView.builder(
                            itemCount: beritaList.length,
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
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
