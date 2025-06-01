import 'package:flutter/foundation.dart';
import 'package:mediaexplant/features/bookmark/bookmarkRepo/berita_bookmark_repository.dart';
import 'package:mediaexplant/features/home/models/berita/berita.dart';

class BeritaBookamarkViewmodel with ChangeNotifier {
  final BeritaBookmarkRepository _repository = BeritaBookmarkRepository();
  final int _limit = 10;
  int _page = 1;
  bool hasMore = true;
  List<Berita> _beritas = [];
  bool isLoading = false;

  List<Berita> get allBerita => _beritas;

  Future<void> fetchBeritaBookmark(String? userId) async {
    if (isLoading) return;
    isLoading = true;
    try {
      final response =
          await _repository.fetchBeritaBookmark(_page, _limit, userId);

      if (response.length < _limit) {
        hasMore = false;
      }

      _beritas.addAll(response);
      _page++;

      notifyListeners();
    } catch (e) {
      if (kDebugMode) print("Error fetchBeritaBookmark: $e");
    } finally {
      isLoading = false;
    }
  }

  Future<void> refresh(String? userId) async {
    _page = 1;
    hasMore = true;
    isLoading = false;
    _beritas = [];

    await fetchBeritaBookmark(userId);
    notifyListeners();
  }
}
