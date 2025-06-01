
import 'package:flutter/foundation.dart';
import 'package:mediaexplant/features/home/models/produk/produk.dart';
import 'package:mediaexplant/features/home/presentation/logic/repository/produkRepo/produk_terkait_ropository.dart';

class ProdukTerkaitViewmodel with ChangeNotifier {
  final ProdukTerkaitRopository _repository = ProdukTerkaitRopository();
  final int _limit = 6;
  int _page = 1;
  bool hasMore = true;
  List<Produk> _produk = [];
  bool isLoading = false;

  List<Produk> get allProduk => _produk;

  Future<void> fetchProdukTerkait(
  String? userId, String produkId) async {
    if (isLoading) return;
    isLoading = true;
    try {
      final response =
          await _repository.fetchProdukTerkait(_page, _limit, userId, produkId);

      if (response.length < _limit) {
        hasMore = false;
      }

      _produk.addAll(response);
      _page++;

      notifyListeners();
    } catch (e) {
      if (kDebugMode) print("Error fetchProdukTerkait: $e");
    } finally {
      isLoading = false;
    }
  }

  Future<void> refresh(String? userId, String produkId) async {
    _page = 1;
    hasMore = true;
    isLoading = false;
    _produk = [];

    await fetchProdukTerkait(userId, produkId);
    notifyListeners();
  }
}
