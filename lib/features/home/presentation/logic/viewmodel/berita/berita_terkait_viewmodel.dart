import 'package:flutter/foundation.dart';
import 'package:mediaexplant/features/home/models/berita/berita.dart';
import 'package:mediaexplant/features/home/presentation/logic/repository/beritaRepo/berita_terkait_repository.dart';

class BeritaTerkaitViewmodel with ChangeNotifier {
  final BeritaTerkaitRepository _repository = BeritaTerkaitRepository();
  final int _limit = 10;
  int _page = 1;
  bool hasMore = true;
  List<Berita> _beritas = [];
  bool isLoading = false;

  List<Berita> get allBerita => _beritas;

  Future<void> fetchBeritaTerkait(
    String? userId,
    String kategori,
    String beritaId,
  ) async {
    if (isLoading) return;
    isLoading = true;
    try {
      final response = await _repository.fetchBeritaTerkait(
        _page,
        _limit,
        userId,
        kategori,
        beritaId,
      );

      if (response.length < _limit) {
        hasMore = false;
      }

      _beritas.addAll(response);
      _page++;

      notifyListeners();
    } catch (e) {
      if (kDebugMode) print("Error fetchBeritaTerkait: $e");
    } finally {
      isLoading = false;
    }
  }

  Future<void> refresh(
    String? userId,
    String kategori,
    String beritaId,
  ) async {
    _page = 1;
    hasMore = true;
    _beritas = [];

    await fetchBeritaTerkait(userId, kategori, beritaId);
    notifyListeners();
  }
}
