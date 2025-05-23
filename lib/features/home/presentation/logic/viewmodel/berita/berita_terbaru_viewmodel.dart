import 'package:flutter/foundation.dart';
import 'package:mediaexplant/features/home/models/berita/berita.dart';
import 'package:mediaexplant/features/home/presentation/logic/repository/beritaRepo/berita_terbaru_repository.dart';

class BeritaTerbaruViewmodel with ChangeNotifier {
  final BeritaTerbaruRepository _repository = BeritaTerbaruRepository();
  final int _limit = 10;
  int _page = 1;
  bool hasMore = true;
  List<Berita> _beritas = [];
  bool isLoading = false;

  List<Berita> get allBerita => _beritas;

  Future<void> fetchBeritaTerbaru(String? userId) async {
    if (isLoading) return;
    isLoading = true;
    try {
      final response =
          await _repository.fetchBeritaTerbaru(_page, _limit, userId);

      if (response.length < _limit) {
        hasMore = false;
      }

      _beritas.addAll(response);
      _page++;

      notifyListeners();
    } catch (e) {
      if (kDebugMode) print("Error fetchBeritaTerbaru: $e");
    } finally {
      isLoading = false;
    }
  }

  Future<void> refresh(String? userId) async {
    _page = 1;
    hasMore = true;
    isLoading = false;
    _beritas = [];

    await fetchBeritaTerbaru(userId);
    notifyListeners();
  }
}
