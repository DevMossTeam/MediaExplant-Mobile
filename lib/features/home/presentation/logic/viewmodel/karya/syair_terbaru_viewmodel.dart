import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:mediaexplant/core/network/api_client.dart';
import 'package:mediaexplant/features/home/models/karya/karya.dart';

class SyairTerbaruViewmodel with ChangeNotifier {
  List<Karya> _allSyair = [];
  bool _isLoaded = false;

  List<Karya> get allSyair => _allSyair;
  bool get isLoaded => _isLoaded;

  Future<void> fetchSyairTerbaru(String? userId) async {
    if (_isLoaded) return;

    final url = Uri.parse("${ApiClient.baseUrl}/syair/terbaru?user_id=$userId");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _allSyair = data.map((item) => Karya.fromJson(item)).toList();
        _isLoaded = true;
        notifyListeners();
      } else {
        throw Exception("Gagal mengambil syair");
      }
    } catch (error) {
      rethrow;
    }
  }

  void resetChange() {
    _isLoaded = false;
    _allSyair = [];
    notifyListeners();
  }
}
