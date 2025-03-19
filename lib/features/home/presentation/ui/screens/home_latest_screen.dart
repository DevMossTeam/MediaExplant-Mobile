import 'package:flutter/material.dart';
import 'package:mediaexplant/features/home/data/repositories/news_repository_impl.dart';
import 'package:mediaexplant/features/home/presentation/ui/screens/detail_berita_screen.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita_populer_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita_terkini_item.dart';

class HomeLatestScreen extends StatelessWidget {
  const HomeLatestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // **Judul Berita Terkini**
          // const Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 10),
          //   child: const Text(
          //     "Berita Terkini",
          //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          //   ),
          // ),
          const SizedBox(height: 8),

          // **Berita Terkini**
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 1,
            itemBuilder: (context, index) {
              return BeritaTerkiniItem(
                berita: dummyBerita[index],
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailBeritaScreen(
                          berita: dummyBerita[index]), // Pakai named argument
                    ),
                    (route) =>
                        route.isFirst, // HomeLatestScreen tetap ada di stack
                  );

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Anda mengeklik ${dummyBerita[index].judul}"),
                    duration: const Duration(seconds: 2),
                  ));
                },
              );
            },
          ),

          // **Berita Terkait**
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: dummyBerita.length,
            itemBuilder: (context, index) {
              return BeritaPopulerItem(
                berita: dummyBerita[index],
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailBeritaScreen(
                          berita: dummyBerita[index]), // Pakai named argument
                    ),
                    (route) =>
                        route.isFirst, // HomeLatestScreen tetap ada di stack
                  );
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Anda mengeklik ${dummyBerita[index].judul}"),
                    duration: const Duration(seconds: 2),
                  ));
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
