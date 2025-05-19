import 'package:flutter/foundation.dart';
import 'package:mediaexplant/features/home/models/berita/berita.dart';
import 'package:mediaexplant/features/home/presentation/logic/repository/beritaRepo/berita_rekomendasi_lain_repository.dart';

class BeritaRekomendasiLainViewModel with ChangeNotifier {
  final BeritaRekomendasiLainRepository _repository =
      BeritaRekomendasiLainRepository();
  final int _limit = 10;
  int _page = 1;
  bool hasMore = true;
  List<Berita> _beritas = [];
  bool isLoading = false;

  List<Berita> get allBerita => _beritas;

  Future<void> fetchBeritaRekomendasiLain(String? userId) async {
    if (isLoading) return;
    isLoading = true;

    try {
      final response = await _repository.fetchBeritaRekomendasiLain(
        _page,
        _limit,
        userId,
      );

      if (response.length < _limit) {
        hasMore = false;
      }

      _beritas.addAll(response);
      _page++;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) print("Error fetchBeritaRekomendasiLain: $e");
    } finally {
      isLoading = false;
    }
  }

  Future<void> refresh(String? userId) async {
    _page = 1;
    hasMore = true;
    _beritas = [];
    await fetchBeritaRekomendasiLain(userId);
  }
}
