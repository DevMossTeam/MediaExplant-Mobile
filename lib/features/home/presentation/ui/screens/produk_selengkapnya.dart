// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/produk/produk_selengkapnya_item.dart';
import 'package:provider/provider.dart';
import 'package:mediaexplant/core/constants/app_colors.dart';
import 'package:mediaexplant/core/utils/userID.dart';
import 'package:mediaexplant/features/home/models/produk/produk.dart';
import 'package:mediaexplant/features/home/presentation/logic/repository/produkRepo/produk_repository.dart';

enum KategoriProduk { majalah, buletin, terkait }

class ProdukSelengkapnya extends StatefulWidget {
  final KategoriProduk kategori;
  final String? produkTerkait;
  final String? kategoriTerkait;
  const ProdukSelengkapnya({
    Key? key,
    required this.kategori,
    this.produkTerkait,
    this.kategoriTerkait,
  }) : super(key: key);

  @override
  State<ProdukSelengkapnya> createState() => _produksSelengkapnyaState();
}

class _produksSelengkapnyaState extends State<ProdukSelengkapnya> {
  final ScrollController _scrollController = ScrollController();

  void _onScroll() {
    double maxScroll = _scrollController.position.maxScrollExtent;
    double currentScroll = _scrollController.position.pixels;

    if (currentScroll == maxScroll &&
        context.read<ProdukSelengkapnyaViewModel>().hasMore) {
      context.read<ProdukSelengkapnyaViewModel>().fetchProduk();
    }
  }

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      print(
          "ProdukSelengkapnya.initState => kategori: ${widget.kategori}, produkTerkait: ${widget.produkTerkait}, kategoriTerkait: ${widget.kategoriTerkait}");
    }
    context.read<ProdukSelengkapnyaViewModel>().setKategori(
          widget.kategori,
          produkId: widget.produkTerkait,
          KategoriProduk: widget.kategoriTerkait,
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
        title: const Text("Semua Produk"),
        backgroundColor: AppColors.background,
      ),
      body: Consumer<ProdukSelengkapnyaViewModel>(
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
              itemCount: vm.hasMore ? vm.produk.length + 1 : vm.produk.length,
              itemBuilder: (context, index) {
                if (index < vm.produk.length) {
                  return ChangeNotifierProvider.value(
                    value: vm.produk[index],
                    child: const ProdukSelengkapnyaItem(),
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

class ProdukSelengkapnyaViewModel with ChangeNotifier {
  final int _limit = 5;
  int _page = 1;
  bool hasMore = true;
  bool isLoading = false;

  List<Produk> _produks = [];
  List<Produk> get produk => _produks;

  late KategoriProduk kategori;
  String? produkTerkait;
  String? kategoriTerkait;

  Future<void> setKategori(KategoriProduk kategoriDipilih,
      {String? produkId, String? KategoriProduk}) async {
    kategori = kategoriDipilih;
    produkTerkait = produkId;
    kategoriTerkait = KategoriProduk;
    if (kDebugMode) {
      print(
          "setKategori called => kategori: $kategori, produkTerkait: $produkTerkait, kategoriTerkait: $kategoriTerkait");
    }
    _produks = [];
    _page = 1;
    hasMore = true;
    await fetchProduk();
  }

  Future<void> fetchProduk() async {
    if (isLoading || !hasMore) return;

    isLoading = true;

    try {
      List<Produk> result = [];

      switch (kategori) {
        case KategoriProduk.terkait:
          result = await ProdukRepository().fetchMajalah(
            _page,
            _limit,
            userLogin,
          );
          break;
        case KategoriProduk.majalah:
          result =
              await ProdukRepository().fetchMajalah(_page, _limit, userLogin);
          break;
        case KategoriProduk.buletin:
          result =
              await ProdukRepository().fetchBuletin(_page, _limit, userLogin);
          break;
      }

      if (result.length < _limit) hasMore = false;

      _produks.addAll(result);
      _page++;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) print("fetchProduk error: $e");
    }

    isLoading = false;
  }
}
