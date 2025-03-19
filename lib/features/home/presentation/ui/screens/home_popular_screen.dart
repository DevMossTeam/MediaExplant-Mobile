import 'package:flutter/material.dart';
import 'package:mediaexplant/features/home/data/providers/berita_provider.dart';
import 'package:mediaexplant/features/home/data/repositories/news_repository_impl.dart';
import 'package:mediaexplant/features/home/presentation/ui/screens/detail_berita_screen.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita_populer_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita_rekomendasi_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/tag_populer_item.dart';
import 'package:provider/provider.dart';

class HomePopularScreen extends StatelessWidget {
  const HomePopularScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final beritaProvider = Provider.of<BeritaProvider>(context);
    final beritaList = beritaProvider.allBerita;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                      child: BeritaPopulerItem(
                        // berita: beritaList[index],
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailBeritaScreen(berita: beritaList[index]),
                            ),
                            (route) => route.isFirst,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                "Anda mengeklik ${beritaList[index].judul}"),
                            duration: const Duration(seconds: 2),
                          ));
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: const Text(
              "Yang kami sarankan",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: beritaList.length,
              itemBuilder: (context, index) {
                return ChangeNotifierProvider.value(
                  value: beritaList[index],
                  child: BeritaRekomendasiItem(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetailBeritaScreen(berita: beritaList[index]),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: const Text(
              "Tag Terpopuler",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
