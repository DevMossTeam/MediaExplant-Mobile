import 'package:flutter/foundation.dart';
import 'package:mediaexplant/features/home/models/berita/berita.dart';
import 'package:mediaexplant/features/home/presentation/logic/repository/beritaRepo/berita_dari_kami_repository.dart';

class BeritaDariKamiViewmodel with ChangeNotifier {
  final BeritaDariKamiRepository _repository = BeritaDariKamiRepository();
  final int _limit = 10;
  int _page = 1;
  bool hasMore = true;
  List<Berita> _beritas = [];
  bool isLoading = false;

  List<Berita> get allBerita => _beritas;

  Future<void> fetchBeritaDariKami(String? userId) async {
    if (isLoading) return;
    isLoading = true;
    try {
      List<Berita> response =
          await _repository.fetchBeritaDariKami(_page, _limit, userId);

      if (response.length < _limit) {
        hasMore = false;
      }

      _beritas.addAll(response);
      _page++;

      notifyListeners();
    } catch (e) {
      if (kDebugMode) print("Error fetchBeritaDariKami: ${e.toString()}");
    } finally {
      isLoading = false;
    }
  }

  Future<void> refresh(String? userId) async {
    _page = 1;
    hasMore = true;
    _beritas = [];
    await fetchBeritaDariKami(userId);
  }
}
