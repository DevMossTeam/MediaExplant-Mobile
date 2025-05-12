import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mediaexplant/core/network/api_client.dart';
import 'package:mediaexplant/features/home/models/berita/berita.dart';

class SearchBeritaViewModel extends ChangeNotifier {
  List<Berita> _hasilPencarian = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Berita> get hasilPencarian => _hasilPencarian;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> searchBerita({required String query, String? userId}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final url = Uri.parse(
        "${ApiClient.baseUrl}/berita/search?q=$query${userId != null ? '&user_id=$userId' : ''}");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _hasilPencarian = data.map((e) => Berita.fromJson(e)).toList();
      } else {
        _errorMessage = 'Gagal memuat data: ${response.statusCode}';
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> searchByKategori(
      {required String kategori, String? userId}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final url = Uri.parse(
        "${ApiClient.baseUrl}/berita/search/kategori?kategori=$kategori${userId != null ? '&user_id=$userId' : ''}");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _hasilPencarian = data.map((e) => Berita.fromJson(e)).toList();
      } else {
        _errorMessage = 'Gagal memuat data: ${response.statusCode}';
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  void clearSearch() {
    _hasilPencarian = [];
    notifyListeners();
  }
}
