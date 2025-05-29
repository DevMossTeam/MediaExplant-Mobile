import 'package:flutter/foundation.dart';
import 'package:mediaexplant/features/home/models/karya/karya.dart';
import 'package:mediaexplant/features/home/presentation/logic/repository/karya/karya_repository.dart';


class SyairViewmodel with ChangeNotifier {
  final KaryaRepository _repository;
  List<Karya> _allSyair = [];
  bool _isLoaded = false;

  SyairViewmodel(this._repository);

  List<Karya> get allSyair => _allSyair;
  bool get isLoaded => _isLoaded;

  Future<void> fetchSyair(String? userId) async {
    if (_isLoaded) return;
    _allSyair = await _repository.fetchKarya("syair/terbaru", userId);
    _isLoaded = true;
    notifyListeners();
  }

  void resetCache() {
    _isLoaded = false;
    _allSyair = [];
    notifyListeners();
  }
}
