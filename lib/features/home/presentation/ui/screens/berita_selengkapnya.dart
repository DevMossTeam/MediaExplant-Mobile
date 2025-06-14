// ignore_for_file: public_member_api_docs, sort_constructors_first
// berita_selengkapnya_screen.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mediaexplant/core/constants/app_colors.dart';
import 'package:mediaexplant/core/utils/userID.dart';
import 'package:mediaexplant/features/home/presentation/logic/repository/beritaRepo/berita_topik_lainnya_repository.dart';

import 'package:provider/provider.dart';

import 'package:mediaexplant/features/home/models/berita/berita.dart';
import 'package:mediaexplant/features/home/presentation/logic/repository/beritaRepo/berita_dari_kami_repository.dart';
import 'package:mediaexplant/features/home/presentation/logic/repository/beritaRepo/berita_hot_repository.dart';
import 'package:mediaexplant/features/home/presentation/logic/repository/beritaRepo/berita_terbaru_repository.dart';
import 'package:mediaexplant/features/home/presentation/logic/repository/beritaRepo/berita_terkait_repository.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita/berita_populer_item.dart';

enum KategoriBerita {
  terbaru,
  rekomendasiLain,
  rekomendasi,
  terkait,
  topiklainnya
}

class BeritaSelengkapnya extends StatefulWidget {
  final KategoriBerita kategori;
  final String? beritaIdTerkait;
  final String? kategoriTerkait;
  const BeritaSelengkapnya({
    Key? key,
    required this.kategori,
    this.beritaIdTerkait,
    this.kategoriTerkait,
  }) : super(key: key);

  @override
  State<BeritaSelengkapnya> createState() => _BeritaSelengkapnyaState();
}

class _BeritaSelengkapnyaState extends State<BeritaSelengkapnya> {
  final ScrollController _scrollController = ScrollController();

  void _onScroll() {
    double maxScroll = _scrollController.position.maxScrollExtent;
    double currentScroll = _scrollController.position.pixels;

    if (currentScroll == maxScroll &&
        context.read<BeritaSelengkapnyaViewModel>().hasMore) {
      context.read<BeritaSelengkapnyaViewModel>().fetchBerita();
    }
  }

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      print(
          "BeritaSelengkapnya.initState => kategori: ${widget.kategori}, beritaIdTerkait: ${widget.beritaIdTerkait}, kategoriTerkait: ${widget.kategoriTerkait}");
    }
    context.read<BeritaSelengkapnyaViewModel>().setKategori(
          widget.kategori,
          beritaId: widget.beritaIdTerkait,
          kategoriBerita: widget.kategoriTerkait,
        );
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Berita selengkapnya"),
        backgroundColor: AppColors.background,
      ),
      body: Consumer<BeritaSelengkapnyaViewModel>(
        builder: (context, vm, _) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ListView.builder(
              controller: _scrollController,
              itemCount: vm.hasMore ? vm.berita.length + 1 : vm.berita.length,
              itemBuilder: (context, index) {
                if (index < vm.berita.length) {
                  return ChangeNotifierProvider.value(
                    value: vm.berita[index],
                    child: BeritaPopulerItem(),
                  );
                } else {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}

class BeritaSelengkapnyaViewModel with ChangeNotifier {
  final int _limit = 10;
  int _page = 1;
  bool hasMore = true;
  bool isLoading = false;

  List<Berita> _beritas = [];
  List<Berita> get berita => _beritas;

  late KategoriBerita kategori;
  String? beritaIdTerkait;
  String? kategoriTerkait;

  Future<void> setKategori(KategoriBerita kategoriDipilih,
      {String? beritaId, String? kategoriBerita}) async {
    kategori = kategoriDipilih;
    beritaIdTerkait = beritaId;
    kategoriTerkait = kategoriBerita;
    if (kDebugMode) {
      print(
          "setKategori called => kategori: $kategori, beritaIdTerkait: $beritaIdTerkait, kategoriTerkait: $kategoriTerkait");
    }
    _beritas = [];
    _page = 1;
    hasMore = true;
    await fetchBerita();
  }

  Future<void> fetchBerita() async {
    if (isLoading || !hasMore) return;

    isLoading = true;

    try {
      List<Berita> result = [];

      switch (kategori) {
        case KategoriBerita.terkait:
          result = await BeritaTerkaitRepository().fetchBeritaTerkait(
            _page,
            _limit,
            userLogin,
            kategoriTerkait!,
            beritaIdTerkait!,
          );
          break;
        case KategoriBerita.topiklainnya:
          result = await BeritaTopikLainnyaRepository().fetchBeritaTopikLainnya(
            _page,
            _limit,
            userLogin,
            kategoriTerkait!,
            beritaIdTerkait!,
          );
          break;
        case KategoriBerita.terbaru:
          result = await BeritaTerbaruRepository()
              .fetchBeritaTerbaru(_page, _limit, userLogin);
          break;
        case KategoriBerita.rekomendasiLain:
          result = await BeritaHotRepository()
              .fetchBeritaHot(_page, _limit, userLogin);
          break;
        case KategoriBerita.rekomendasi:
          result = await BeritaDariKamiRepository()
              .fetchBeritaDariKami(_page, _limit, userLogin);
          break;
      }

      if (result.length < _limit) hasMore = false;

      _beritas.addAll(result);
      _page++;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) print("fetchBerita error: $e");
    }

    isLoading = false;
  }
}
