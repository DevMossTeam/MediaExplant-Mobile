import 'package:flutter/material.dart';
import 'package:mediaexplant/features/home/data/models/berita.dart';
import 'package:mediaexplant/features/home/data/providers/berita_provider.dart';
import 'package:mediaexplant/features/home/data/repositories/news_repository_impl.dart';
import 'package:mediaexplant/features/home/presentation/ui/screens/detail_berita_screen.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita_populer_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita_terkini_item.dart';
import 'package:provider/provider.dart';

class HomeLatestScreen extends StatelessWidget {
  const HomeLatestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final beritaProvider = Provider.of<BeritaProvider>(context);
    final beritaList = beritaProvider.allBerita;
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
              return ChangeNotifierProvider.value(
                value: beritaList[index],
                child: BeritaTerkiniItem(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailBeritaScreen(
                            berita: beritaList[index]), // Pakai named argument
                      ),
                      (route) =>
                          route.isFirst, // HomeLatestScreen tetap ada di stack
                    );

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content:
                          Text("Anda mengeklik ${beritaList[index].judul}"),
                      duration: const Duration(seconds: 2),
                    ));
                  },
                ),
              );
            },
          ),

          // **Berita Terkait**
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: beritaList.length,
            itemBuilder: (context, index) {
              return ChangeNotifierProvider.value(
                value: beritaList[index],
                child: BeritaPopulerItem(
                  // berita: beritaList[index],
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailBeritaScreen(
                            berita: beritaList[index]), // Pakai named argument
                      ),
                      (route) =>
                          route.isFirst, // HomeLatestScreen tetap ada di stack
                    );
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content:
                          Text("Anda mengeklik ${beritaList[index].judul}"),
                      duration: const Duration(seconds: 2),
                    ));
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
