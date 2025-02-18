import 'package:flutter/material.dart';
import '../../domain/entities/article.dart';
import '../../domain/usecases/get_popular_news.dart';

class BeritaPopulerViewModel extends ChangeNotifier {
  final GetPopularNews getPopularNewsUseCase;

  BeritaPopulerViewModel({required this.getPopularNewsUseCase});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Article> _articles = [];
  List<Article> get articles => _articles;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchPopularNews() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _articles = await getPopularNewsUseCase();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
