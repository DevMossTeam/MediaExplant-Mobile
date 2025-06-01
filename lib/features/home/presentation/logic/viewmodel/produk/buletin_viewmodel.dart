import 'package:flutter/foundation.dart';
import 'package:mediaexplant/features/home/models/produk/produk.dart';
import 'package:mediaexplant/features/home/presentation/logic/repository/produkRepo/produk_repository.dart';

class BuletinViewmodel with ChangeNotifier {
  final ProdukRepository _repository = ProdukRepository();
  final int _limit = 5;
  int _page = 1;
  bool hasMore = true;
  bool isLoading = false;
  List<Produk> _buletinList = [];

  List<Produk> get allBuletin => _buletinList;

  Future<void> fetchBuletin(String? userId) async {
    if (isLoading || !hasMore) return;
    isLoading = true;
    try {
      final result = await _repository.fetchBuletin(_page, _limit, userId);

      if (result.length < _limit) hasMore = false;
      _buletinList.addAll(result);
      _page++;

      notifyListeners();
    } catch (e) {
      if (kDebugMode) print("Error fetchBuletin: $e");
    } finally {
      isLoading = false;
    }
  }

  Future<void> refresh(String? userId) async {
    _page = 1;
    hasMore = true;
    isLoading = false;
    _buletinList = [];

    await fetchBuletin(userId);
    notifyListeners();
  }
}
