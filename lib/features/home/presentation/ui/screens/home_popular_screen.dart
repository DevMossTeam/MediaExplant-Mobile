import 'package:flutter/material.dart';
import 'package:mediaexplant/features/home/data/repositories/news_repository_impl.dart';
import 'package:mediaexplant/features/home/presentation/ui/screens/detail_berita_screen.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita_populer_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita_rekomendasi_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/tag_populer_item.dart';

class HomePopularScreen extends StatelessWidget {
  const HomePopularScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            itemCount: dummyBerita.length,
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
                    child: BeritaPopulerItem(
                      berita: dummyBerita[index],
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailBeritaScreen(berita: dummyBerita[index]),
                          ),
                          (route) => route.isFirst,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              "Anda mengeklik ${dummyBerita[index].judul}"),
                          duration: const Duration(seconds: 2),
                        ));
                      },
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
              itemCount: dummyBerita.length,
              itemBuilder: (context, index) {
                return BeritaRekomendasiItem(
                  berita: dummyBerita[index],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailBeritaScreen(berita: dummyBerita[index]),
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
