import 'package:flutter/material.dart';
import 'package:mediaexplant/core/constants/app_colors.dart';
import 'package:mediaexplant/features/home/presentation/logic/berita_terkini_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita_populer_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita_rekomendasi_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/komentar_terbanyak_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/tag_populer_item.dart';
import 'package:provider/provider.dart';

class HomePopularScreen extends StatelessWidget {
  const HomePopularScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final beritaProvider = Provider.of<BeritaTerkiniViewmodel>(context);
    final beritaList = beritaProvider.allBerita;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [
                  AppColors.primary,
                  Colors.red,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: const Text(
                "Berita Terpopuler",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: beritaList.length,
            itemBuilder: (context, index) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Nomor Indexing
                  Container(
                    width: 30,
                    alignment: Alignment.center,
                    child: Text(
                      "${index + 1}",
                      style: const TextStyle(
                        color: Color.fromARGB(255, 105, 104, 104),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [
                  AppColors.primary,
                  Colors.red,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: const Text(
                "Yang Kami Sarankan",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 230,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: beritaList.length,
              itemBuilder: (context, index) {
                return ChangeNotifierProvider.value(
                  value: beritaList[index],
                  child: BeritaRekomendasiItem(),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [
                  AppColors.primary,
                  Colors.red,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: const Text(
                "Tag Terpopuler",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(
            child: ListView.builder(
              shrinkWrap: true, // Menyesuaikan ukuran dengan isi list
              physics:
                  const NeverScrollableScrollPhysics(), // Mencegah scroll ganda
              itemCount: 7,
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [
                  AppColors.primary,
                  Colors.red,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: const Text(
                "Komentar Terbanyak",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true, // Menyesuaikan ukuran dengan isi list
            physics:
                const NeverScrollableScrollPhysics(), // Mencegah scroll ganda
            itemCount: beritaList.length,
            itemBuilder: (context, index) {
              return ChangeNotifierProvider.value(
                  value: beritaList[index], child: KomentarTerbanyakItem());
            },
          ),
        ],
      ),
    );
  }
}
