import 'package:flutter/foundation.dart';
import 'package:mediaexplant/features/home/models/berita/berita.dart';
import 'package:mediaexplant/features/home/presentation/logic/repository/beritaRepo/berita_populer_repository.dart';

class BeritaPopulerViewmodel with ChangeNotifier {
  final BeritaTerpopulerRepository _repository = BeritaTerpopulerRepository();
  List<Berita> _beritas = [];
  bool isLoading = false;

  List<Berita> get allBerita => _beritas;

  Future<void> fetchBeritaPopuler(String? userId) async {
    if (isLoading) return;
    isLoading = true;

    try {
      final response = await _repository.fetchBeritaPopuler(userId);

      _beritas = response;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) print("Error fetchBeritaPopuler: ${e.toString()}");
    } finally {
      isLoading = false;
    }
  }

  Future<void> refresh(String? userId) async {
    _beritas = [];
    await fetchBeritaPopuler(userId);
  }
}
