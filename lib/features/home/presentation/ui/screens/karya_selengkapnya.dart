import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mediaexplant/core/constants/app_colors.dart';
import 'package:mediaexplant/core/utils/userID.dart';
import 'package:mediaexplant/features/home/models/karya/karya.dart';
import 'package:mediaexplant/features/home/presentation/logic/repository/karya/karya_repository.dart';
import 'package:mediaexplant/features/home/presentation/logic/repository/karya/karya_terkait_repository.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/karya/karya_selengkapnya_item.dart';
import 'package:provider/provider.dart';

enum KategoriKarya { puisi, syair, pantun, desainGrafis, terkait, fotografi }

class KaryaSelengkapnya extends StatefulWidget {
  final KategoriKarya kategori;
  final String? KaryaIdTerkait;
  final String? kategoriTerkait;
  const KaryaSelengkapnya({
    Key? key,
    required this.kategori,
    this.KaryaIdTerkait,
    this.kategoriTerkait,
  }) : super(key: key);

  @override
  State<KaryaSelengkapnya> createState() => _KaryaSelengkapnyaState();
}

class _KaryaSelengkapnyaState extends State<KaryaSelengkapnya> {
  final ScrollController _scrollController = ScrollController();

  void _onScroll() {
    double maxScroll = _scrollController.position.maxScrollExtent;
    double currentScroll = _scrollController.position.pixels;

    if (currentScroll == maxScroll &&
        context.read<KaryaSelengkapnyaViewModel>().hasMore) {
      context.read<KaryaSelengkapnyaViewModel>().fetchKarya();
    }
  }

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      print(
          "KaryaSelengkapnya.initState => kategori: ${widget.kategori}, KaryaIdTerkait: ${widget.KaryaIdTerkait}, kategoriTerkait: ${widget.kategoriTerkait}");
    }
    context.read<KaryaSelengkapnyaViewModel>().setKategori(
          widget.kategori,
          KaryaId: widget.KaryaIdTerkait,
          KategoriKarya: widget.kategoriTerkait,
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
        title: const Text("Semua Karya "),
        backgroundColor: AppColors.background,
      ),
      body: Consumer<KaryaSelengkapnyaViewModel>(
        builder: (context, vm, _) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: GridView.builder(
              controller: _scrollController,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 5,
                childAspectRatio: 0.55,
              ),
              itemCount: vm.hasMore ? vm.karya.length + 1 : vm.karya.length,
              itemBuilder: (context, index) {
                if (index < vm.karya.length) {
                  return ChangeNotifierProvider.value(
                    value: vm.karya[index],
                    child: KaryaSelengkapnyaItem(),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          );
        },
      ),
    );
  }
}

class KaryaSelengkapnyaViewModel with ChangeNotifier {
  final int _limit = 5;
  int _page = 1;
  bool hasMore = true;
  bool isLoading = false;

  List<Karya> _karya = [];
  List<Karya> get karya => _karya;

  late KategoriKarya kategori;
  String? KaryaIdTerkait;
  String? kategoriTerkait;

  Future<void> setKategori(KategoriKarya kategoriDipilih,
      {String? KaryaId, String? KategoriKarya}) async {
    kategori = kategoriDipilih;
    KaryaIdTerkait = KaryaId;
    kategoriTerkait = KategoriKarya;
    if (kDebugMode) {
      print(
          "setKategori called => kategori: $kategori, KaryaIdTerkait: $KaryaIdTerkait, kategoriTerkait: $kategoriTerkait");
    }
    _karya = [];
    _page = 1;
    hasMore = true;
    await fetchKarya();
  }

  Future<void> fetchKarya() async {
    if (isLoading || !hasMore) return;

    isLoading = true;

    try {
      List<Karya> result = [];

      switch (kategori) {
        case KategoriKarya.terkait:
          result = await KaryaTerkaitRepository().fetchKaryaTerkait(
            _page,
            _limit,
            userLogin,
            KaryaIdTerkait!,
          );
          break;
        case KategoriKarya.fotografi:
          result = await KaryaRepository()
              .fetchKarya("fotografi/terbaru", _page, _limit, userLogin);
          break;
        case KategoriKarya.puisi:
          result = await KaryaRepository()
              .fetchKarya("puisi/terbaru", _page, _limit, userLogin);
          break;
        case KategoriKarya.syair:
          result = await KaryaRepository()
              .fetchKarya("syair/terbaru", _page, _limit, userLogin);
          break;
        case KategoriKarya.pantun:
          result = await KaryaRepository()
              .fetchKarya("pantun/terbaru", _page, _limit, userLogin);
          break;
        case KategoriKarya.desainGrafis:
          result = await KaryaRepository()
              .fetchKarya("desain-grafis/terbaru", _page, _limit, userLogin);
          break;
      }

      if (result.length < _limit) hasMore = false;

      _karya.addAll(result);
      _page++;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) print("fetchKarya error: $e");
    }

    isLoading = false;
  }
}
