import 'package:flutter/foundation.dart';
import 'package:mediaexplant/features/bookmark/bookmarkRepo/produk_bookmark_repository.dart';
import 'package:mediaexplant/features/home/models/produk/produk.dart';

class ProdukBookmarkViewmodel with ChangeNotifier {
  final ProdukBookmarkRepository _repository = ProdukBookmarkRepository();
  final int _limit = 10;
  int _page = 1;
  bool hasMore = true;
  List<Produk> _produk = [];
  bool isLoading = false;

  List<Produk> get allProduk => _produk;

  Future<void> fetchProdukBookmark(String? userId) async {
    if (isLoading) return;
    isLoading = true;
    try {
      final response =
          await _repository.fetchProdukBookmark(_page, _limit, userId);

      if (response.length < _limit) {
        hasMore = false;
      }

      _produk.addAll(response);
      _page++;

      notifyListeners();
    } catch (e) {
      if (kDebugMode) print("Error fetchProdukBookmark: $e");
    } finally {
      isLoading = false;
    }
  }

  Future<void> refresh(String? userId) async {
    _page = 1;
    hasMore = true;
    isLoading = false;
    _produk = [];

    await fetchProdukBookmark(userId);
    notifyListeners();
  }
}
