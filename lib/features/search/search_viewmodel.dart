import 'package:flutter/foundation.dart';
import 'package:mediaexplant/features/home/models/berita/berita.dart';
import 'package:mediaexplant/features/search/search_repository.dart';

class SearchBeritaViewModel extends ChangeNotifier {
  final SearchBeritaRepository _repository = SearchBeritaRepository();
  final int _limit = 10;

  int _page = 1;
  bool _hasMore = true;
  bool _isLoading = false;
  String? _errorMessage;
  List<Berita> _hasilPencarian = [];

  List<Berita> get hasilPencarian => _hasilPencarian;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  String? get errorMessage => _errorMessage;

  String _currentQuery = '';
  String? _currentKategori;

  Future<void> searchBerita({required String query, String? userId}) async {
    if (_isLoading || !_hasMore) return;

    if (_currentQuery != query) {
      _resetState();
      _currentQuery = query;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final results = await _repository.searchBerita(
        query: query,
        page: _page,
        limit: _limit,
        userId: userId,
      );

      if (results.length < _limit) _hasMore = false;

      _hasilPencarian.addAll(results);
      _page++;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> searchByKategori({required String kategori, String? userId}) async {
    if (_isLoading || !_hasMore) return;

    if (_currentKategori != kategori) {
      _resetState();
      _currentKategori = kategori;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final results = await _repository.searchByKategori(
        kategori: kategori,
        page: _page,
        limit: _limit,
        userId: userId,
      );

      if (results.length < _limit) _hasMore = false;

      _hasilPencarian.addAll(results);
      _page++;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  void clearSearch() {
    _resetState();
    notifyListeners();
  }

  void _resetState() {
    _hasilPencarian = [];
    _page = 1;
    _hasMore = true;
    _isLoading = false;
    _errorMessage = null;
    _currentQuery = '';
    _currentKategori = null;
  }
}
