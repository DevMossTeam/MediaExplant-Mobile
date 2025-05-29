import 'package:flutter/foundation.dart';
import 'package:mediaexplant/features/home/models/berita/detail_berita.dart';
import 'package:mediaexplant/features/home/presentation/logic/repository/beritaRepo/berita_detail_repository.dart';

class BeritaDetailViewmodel with ChangeNotifier {
  final BeritaDetailRepository _repository = BeritaDetailRepository();

  DetailBerita? _berita;
  bool isLoading = false;

  DetailBerita? get berita => _berita;

  Future<void> fetchBeritaDetail(String? userId, String idBerita) async {
    if (isLoading) return;
    isLoading = true;

    try {
      final response = await _repository.fetchBeritaDetail(userId, idBerita);
      _berita = response;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) print("Error fetchBeritaDetail: ${e.toString()}");
    } finally {
      isLoading = false;
    }
  }

  Future<void> refresh(String? userId, String idBerita) async {
    _berita = null;
    await fetchBeritaDetail(userId, idBerita);
  }
}
