import 'package:flutter/material.dart';
import 'package:mediaexplant/features/home/models/berita/berita.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita/berita_populer_item.dart';

import 'package:provider/provider.dart';

class BeritaSelengkapnya extends StatelessWidget {
  const BeritaSelengkapnya({super.key});

  @override
  Widget build(BuildContext context) {
    final beritaList = context.watch<BeritaSelengkapnyaViewModel>().berita;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Semua Berita"),
      ),
      body: ListView.builder(
        itemCount: beritaList.length,
        itemBuilder: (context, index) {
          return ChangeNotifierProvider.value(
            value: beritaList[index],
            child: const BeritaPopulerItem(),
          );
        },
      ),
    );
  }
}



class BeritaSelengkapnyaViewModel extends ChangeNotifier {
  List<Berita> _berita = [];

  List<Berita> get berita => _berita;

  void setBerita(List<Berita> data) {
    _berita = data;
    notifyListeners();
  }
}