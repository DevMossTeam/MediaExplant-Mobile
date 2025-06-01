import 'package:flutter/foundation.dart';
import 'package:mediaexplant/features/home/models/produk/produk.dart';
import 'package:mediaexplant/features/home/presentation/logic/repository/produkRepo/produk_repository.dart';

class ProdukViewmodel with ChangeNotifier {
  final ProdukRepository _repository = ProdukRepository();
  final int _limit = 10;
  int _pageMajalah = 1;
  int _pageBuletin = 1;
  bool _hasMoreMajalah = true;
  bool _hasMoreBuletin = true;

  List<Produk> _majalahList = [];
  List<Produk> _buletinList = [];
  bool isLoadingMajalah = false;
  bool isLoadingBuletin = false;

  List<Produk> get majalahList => _majalahList;
  List<Produk> get buletinList => _buletinList;
  bool get hasMoreMajalah => _hasMoreMajalah;
  bool get hasMoreBuletin => _hasMoreBuletin;

  Future<void> fetchMajalah(String? userId) async {
    if (isLoadingMajalah || !_hasMoreMajalah) return;

    isLoadingMajalah = true;
    try {
      final result = await _repository.fetchMajalah(_pageMajalah, _limit, userId);

      if (result.length < _limit) _hasMoreMajalah = false;
      _majalahList.addAll(result);
      _pageMajalah++;

      notifyListeners();
    } catch (e) {
      if (kDebugMode) print("Error fetchMajalah: $e");
    } finally {
      isLoadingMajalah = false;
    }
  }

  Future<void> fetchBuletin(String? userId) async {
    if (isLoadingBuletin || !_hasMoreBuletin) return;

    isLoadingBuletin = true;
    try {
      final result = await _repository.fetchBuletin(_pageBuletin, _limit, userId);

      if (result.length < _limit) _hasMoreBuletin = false;
      _buletinList.addAll(result);
      _pageBuletin++;

      notifyListeners();
    } catch (e) {
      if (kDebugMode) print("Error fetchBuletin: $e");
    } finally {
      isLoadingBuletin = false;
    }
  }

  Future<void> refreshMajalah(String? userId) async {
    _pageMajalah = 1;
    _hasMoreMajalah = true;
    _majalahList.clear();
    await fetchMajalah(userId);
  }

  Future<void> refreshBuletin(String? userId) async {
    _pageBuletin = 1;
    _hasMoreBuletin = true;
    _buletinList.clear();
    await fetchBuletin(userId);
  }
}
