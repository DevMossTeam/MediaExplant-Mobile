import 'package:flutter/material.dart';
import 'package:mediaexplant/features/search/models/search.dart';
import 'package:mediaexplant/features/search/search_repository.dart';

class SearchViewModel extends ChangeNotifier {
  final SearchRepository _repository;

  SearchViewModel(this._repository);

  List<Search> _hasil = [];
  bool _isLoading = false;
  String? _error;

  List<Search> get hasil => _hasil;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> cari(String keyword) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _hasil = await _repository.search(keyword);
    } catch (e) {
      _error = e.toString();
      _hasil = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  void clear() {
    _hasil = [];
    _error = null;
    notifyListeners();
  }
}
