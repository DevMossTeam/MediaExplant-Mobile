import 'package:flutter/foundation.dart';
import 'package:mediaexplant/features/home/models/karya/karya.dart';
import 'package:mediaexplant/features/home/presentation/logic/repository/karya/karya_repository.dart';


class DesainGrafisViewmodel with ChangeNotifier {
  final KaryaRepository _repository;
  List<Karya> _allDesainGrafis = [];
  bool _isLoaded = false;

  DesainGrafisViewmodel(this._repository);

  List<Karya> get allDesainGrafis => _allDesainGrafis;
  bool get isLoaded => _isLoaded;

  Future<void> fetchDesainGrafis(String? userId) async {
    if (_isLoaded) return;
    _allDesainGrafis =
        await _repository.fetchKarya("desain-grafis/terbaru", userId);
    _isLoaded = true;
    notifyListeners();
  }

  void resetCache() {
    _isLoaded = false;
    _allDesainGrafis = [];
    notifyListeners();
  }
}
