// import 'package:flutter/foundation.dart';
// import 'package:mediaexplant/features/home/models/karya/karya.dart';
// import 'package:mediaexplant/features/home/presentation/logic/repository/karya/karya_repository.dart';


// class SyairViewmodel with ChangeNotifier {
//   final KaryaRepository _repository;
//   List<Karya> _allSyair = [];
//   bool _isLoaded = false;

//   SyairViewmodel(this._repository);

//   List<Karya> get allSyair => _allSyair;
//   bool get isLoaded => _isLoaded;

//   Future<void> fetchSyair(String? userId) async {
//     if (_isLoaded) return;
//     _allSyair = await _repository.fetchKarya("syair/terbaru", userId);
//     _isLoaded = true;
//     notifyListeners();
//   }

//   void resetCache() {
//     _isLoaded = false;
//     _allSyair = [];
//     notifyListeners();
//   }
// }

import 'package:flutter/foundation.dart';
import 'package:mediaexplant/features/home/models/karya/karya.dart';

import 'package:mediaexplant/features/home/presentation/logic/repository/karya/karya_repository.dart';

class SyairViewmodel with ChangeNotifier {
  final KaryaRepository _repository = KaryaRepository();
  final int _limit = 10;
  int _page = 1;
  bool hasMore = true;
  List<Karya> _karya = [];
  bool isLoading = false;

  List<Karya> get allKarya => _karya;

  Future<void> fetchSyair(String? userId) async {
    if (isLoading) return;
    isLoading = true;
    try {
      final response =
          await _repository.fetchKarya("syair/terbaru", _page, _limit, userId);

      if (response.length < _limit) {
        hasMore = false;
      }

      _karya.addAll(response);
      _page++;

      notifyListeners();
    } catch (e) {
      if (kDebugMode) print("Error fetchSyair: $e");
    } finally {
      isLoading = false;
    }
  }

  Future<void> refresh(String? userId) async {
    _page = 1;
    hasMore = true;
    isLoading = false;
    _karya = [];

    await fetchSyair(userId);
    notifyListeners();
  }
}
