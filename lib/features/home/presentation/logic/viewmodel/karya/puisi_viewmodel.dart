import 'package:flutter/foundation.dart';
import 'package:mediaexplant/features/home/models/karya/karya.dart';

import 'package:mediaexplant/features/home/presentation/logic/repository/karya/karya_repository.dart';

class PuisiViewmodel with ChangeNotifier {
  final KaryaRepository _repository = KaryaRepository();
  final int _limit = 5;
  int _page = 1;
  bool hasMore = true;
  List<Karya> _karya = [];
  bool isLoading = false;

  List<Karya> get allKarya => _karya;

  Future<void> fetchPuisi(String? userId) async {
    if (isLoading) return;
    isLoading = true;
    try {
      final response =
          await _repository.fetchKarya("puisi/terbaru", _page, _limit, userId);

      if (response.length < _limit) {
        hasMore = false;
      }

      _karya.addAll(response);
      _page++;

      notifyListeners();
    } catch (e) {
      if (kDebugMode) print("Error fetchKaryaTerbaru: $e");
    } finally {
      isLoading = false;
    }
  }

  Future<void> refresh(String? userId) async {
    _page = 1;
    hasMore = true;
    isLoading = false;
    _karya = [];

    await fetchPuisi(userId);
    notifyListeners();
  }
}
