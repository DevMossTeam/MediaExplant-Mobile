import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mediaexplant/features/home/models/majalah.dart';

class MajalahViewModel with ChangeNotifier {
  List<Majalah> _allMajalah = [];
  bool _isLoaded = false;

  List<Majalah> get allMajalah => _allMajalah;
  bool get isLoaded => _isLoaded;

  Future<void> fetchMajalah(String userId) async {
    if (_isLoaded) return;

    final url = Uri.parse('http://10.0.2.2:8000/api/produk-majalah?user_id=$userId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        _allMajalah = data.map((item) => Majalah.fromJson(item)).toList();
        _isLoaded = true;
        notifyListeners();
      } else {
        throw Exception("Gagal mengambil Majalah.");
      }
    } catch (error) {
      rethrow;
    }
  }

  void resetCache() {
    _isLoaded = false;
    _allMajalah = [];
    notifyListeners();
  }
}
