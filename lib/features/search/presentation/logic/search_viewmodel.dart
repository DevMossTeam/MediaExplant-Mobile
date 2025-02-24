import 'package:flutter/material.dart';
import '../../domain/usecases/perform_search.dart';

class SearchViewModel extends ChangeNotifier {
  final PerformSearch performSearch;

  List<Search> _results = [];
  List<Search> get results => _results;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  SearchViewModel({required this.performSearch});

  Future<void> search(String query) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _results = await performSearch(query);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}