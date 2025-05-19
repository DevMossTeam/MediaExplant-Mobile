import 'package:flutter/foundation.dart';
import 'package:mediaexplant/features/home/models/berita/berita.dart';
import 'package:mediaexplant/features/home/presentation/logic/repository/beritaRepo/berita_teratas_repository.dart';

class BeritaTeratasViewModel with ChangeNotifier {
  final BeritaTeratasRepository _repository = BeritaTeratasRepository();
  List<Berita> _beritas = [];
  bool isLoading = false;

  List<Berita> get allBerita => _beritas;

  Future<void> fetchBeritaTeratas(String? userId) async {
    if (isLoading) return;
    isLoading = true;
    try {
      final response = await _repository.fetchBeritaTeratas(userId);

      _beritas = response;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) print("Error fetchBeritaTeratas: ${e.toString()}");
    } finally {
      isLoading = false;
    }
  }

  Future<void> refresh(String? userId) async {
    _beritas = [];
    await fetchBeritaTeratas(userId);
  }
}
