
import 'package:flutter/foundation.dart';
import 'package:mediaexplant/features/home/models/karya/karya.dart';
import 'package:mediaexplant/features/home/presentation/logic/repository/karya/karya_terkait_repository.dart';

class KaryaTerkaitViewmodel with ChangeNotifier {
  final KaryaTerkaitRepository _repository = KaryaTerkaitRepository();
  final int _limit = 6;
  int _page = 1;
  bool hasMore = true;
  List<Karya> _karya = [];
  bool isLoading = false;

  List<Karya> get allKarya => _karya;

  Future<void> fetchKaryaTerkait(
  String? userId, String karyaId) async {
    if (isLoading) return;
    isLoading = true;
    try {
      final response =
          await _repository.fetchKaryaTerkait(_page, _limit, userId, karyaId);

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

  Future<void> refresh(String? userId, String karyaId) async {
    _page = 1;
    hasMore = true;
    isLoading = false;
    _karya = [];

    await fetchKaryaTerkait(userId, karyaId);
    notifyListeners();
  }
}
