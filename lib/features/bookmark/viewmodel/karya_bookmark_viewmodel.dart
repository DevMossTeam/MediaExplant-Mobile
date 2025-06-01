import 'package:flutter/foundation.dart';
import 'package:mediaexplant/features/bookmark/bookmarkRepo/karya_bookmark_repositoory.dart';
import 'package:mediaexplant/features/home/models/karya/karya.dart';

class KaryaBookmarkViewmodel with ChangeNotifier {
  final KaryaBookmarkRepository _repository = KaryaBookmarkRepository();
  final int _limit = 10;
  int _page = 1;
  bool hasMore = true;
  List<Karya> _karya = [];
  bool isLoading = false;

  List<Karya> get allkarya => _karya;

  Future<void> fetchKaryaBookmark(String? userId) async {
    if (isLoading) return;
    isLoading = true;
    try {
      final response =
          await _repository.fetchKaryaBookmark(_page, _limit, userId);

      if (response.length < _limit) {
        hasMore = false;
      }

      _karya.addAll(response);
      _page++;

      notifyListeners();
    } catch (e) {
      if (kDebugMode) print("Error fetchKaryaBookmark: $e");
    } finally {
      isLoading = false;
    }
  }

  Future<void> refresh(String? userId) async {
    _page = 1;
    hasMore = true;
    isLoading = false;
    _karya = [];

    await fetchKaryaBookmark(userId);
    notifyListeners();
  }
}
