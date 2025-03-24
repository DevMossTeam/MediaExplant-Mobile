import 'package:flutter/material.dart';
import 'package:mediaexplant/features/home/data/providers/berita_provider.dart';
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
                child: const BeritaTerkiniItem(),
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
                child: BeritaPopulerItem(),
              );
            },
          ),
        ],
      ),
    );
  }
}
