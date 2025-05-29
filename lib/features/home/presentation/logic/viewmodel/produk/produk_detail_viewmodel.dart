import 'package:flutter/foundation.dart';
import 'package:mediaexplant/features/home/models/produk/detail_produk.dart';
import 'package:mediaexplant/features/home/presentation/logic/repository/produkRepo/produk_detail_repository.dart';

class ProdukDetailViewmodel with ChangeNotifier {
  final ProdukDetailRepository _repository = ProdukDetailRepository();

  DetailProduk? _detailProduk;
  bool isLoading = false;

  DetailProduk? get detailProduk => _detailProduk;

  Future<void> fetchProdukDetail(String? userId, String idBerita) async {
    if (isLoading) return;
    isLoading = true;

    try {
      final response = await _repository.fetchProdukDetail(userId, idBerita);
      _detailProduk = response;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) print("Error fetchProdukDetail: ${e.toString()}");
    } finally {
      isLoading = false;
    }
  }

  Future<void> refresh(String? userId, String idBerita) async {
    _detailProduk = null;
    await fetchProdukDetail(userId, idBerita);
  }
}
