import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mediaexplant/features/home/models/berita.dart';

class BeritaPopulerViewmodel with ChangeNotifier {
  List<Berita> _allBerita = [];
  bool _isLoaded = false;

  List<Berita> get allBerita => _allBerita;
  bool get isLoaded => _isLoaded;

  Future<void> fetchBeritaPopuler(String userId) async {
    if (_isLoaded) return;

    final url = Uri.parse('http://10.0.2.2:8000/api/berita/populer?user_id=$userId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        _allBerita = data.map((item) => Berita.fromJson(item)).toList();
        _isLoaded = true;
        notifyListeners();
      } else {
        throw Exception("Gagal mengambil berita.");
      }
    } catch (error) {
      rethrow;
    }
  }

  void resetCache() {
    _isLoaded = false;
    _allBerita = [];
    notifyListeners();
  }
}
