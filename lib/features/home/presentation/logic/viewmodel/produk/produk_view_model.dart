import 'package:flutter/foundation.dart';
import 'package:mediaexplant/features/home/models/produk/produk.dart';
import 'package:mediaexplant/features/home/presentation/logic/repository/produkRepo/produk_repository.dart';

class ProdukViewModel with ChangeNotifier {
  final ProdukRepository _produkRepository;

  ProdukViewModel(this._produkRepository);

  List<Produk> _allMajalah = [];
  List<Produk> _allBuletin = [];
  bool _isMajalahLoaded = false;
  bool _isBuletinLoaded = false;

  List<Produk> get allMajalah => _allMajalah;
  List<Produk> get allBuletin => _allBuletin;
  bool get isMajalahLoaded => _isMajalahLoaded;
  bool get isBuletinLoaded => _isBuletinLoaded;

  Future<void> fetchMajalah(String? userId) async {
    if (_isMajalahLoaded) return;
    try {
      _allMajalah = await _produkRepository.fetchMajalah(userId);
      _isMajalahLoaded = true;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchBuletin(String? userId) async {
    if (_isBuletinLoaded) return;
    try {
      _allBuletin = await _produkRepository.fetchBuletin(userId);
      _isBuletinLoaded = true;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  void resetCache() {
    _allMajalah = [];
    _allBuletin = [];
    _isMajalahLoaded = false;
    _isBuletinLoaded = false;
    notifyListeners();
  }
}
