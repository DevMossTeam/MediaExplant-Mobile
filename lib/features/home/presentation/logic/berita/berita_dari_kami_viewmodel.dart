import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mediaexplant/core/network/api_client.dart';
import 'package:mediaexplant/features/home/models/berita/berita.dart';

class BeritaDariKamiViewmodel with ChangeNotifier {
  List<Berita> _allBerita = [];
  bool _isLoaded = false;

  List<Berita> get allBerita => _allBerita;
  bool get isLoaded => _isLoaded;

  Future<void> fetchBeritaDariKami(String? userId) async {
    
    if (_isLoaded) return;

    final url = Uri.parse("${ApiClient.baseUrl}/berita/rekomendasi?user_id=$userId");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        _allBerita = await compute(parseBeritaList, response.body);
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

/// Fungsi top-level untuk parsing data JSON (digunakan oleh `compute`)
List<Berita> parseBeritaList(String responseBody) {
  final List<dynamic> parsed = json.decode(responseBody);
  return parsed.map<Berita>((json) => Berita.fromJson(json)).toList();
}
