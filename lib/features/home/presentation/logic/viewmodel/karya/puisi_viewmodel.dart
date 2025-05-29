import 'package:flutter/foundation.dart';
import 'package:mediaexplant/features/home/models/karya/karya.dart';
import 'package:mediaexplant/features/home/presentation/logic/repository/karya/karya_repository.dart';


class PuisiViewmodel with ChangeNotifier {
  final KaryaRepository _repository;
  List<Karya> _allPuisi = [];
  bool _isLoaded = false;

  PuisiViewmodel(this._repository);

  List<Karya> get allPuisi => _allPuisi;
  bool get isLoaded => _isLoaded;

  Future<void> fetchPuisi(String? userId) async {
    if (_isLoaded) return;
    _allPuisi = await _repository.fetchKarya("puisi/terbaru", userId);
    _isLoaded = true;
    notifyListeners();
  }

  void resetCache() {
    _isLoaded = false;
    _allPuisi = [];
    notifyListeners();
  }
}
