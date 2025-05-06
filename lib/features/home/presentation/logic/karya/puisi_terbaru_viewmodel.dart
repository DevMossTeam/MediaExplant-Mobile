import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mediaexplant/core/network/api_client.dart';
import 'package:mediaexplant/features/home/models/karya/karya.dart';


// nyambung API

class PuisiTerbaruViewmodel with ChangeNotifier {
  List<Karya> _allPuisi = [];
  bool _isLoaded = false;

  List<Karya> get allPuisi => _allPuisi;
  bool get isLoaded => _isLoaded;

  Future<void> fetchPuisiTerbaru(String userId) async {
    if (_isLoaded) return;

    final url = Uri.parse("${ApiClient.baseUrl}/puisi/terbaru?user_id=$userId");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        _allPuisi = await compute(parsePuisiList, response.body);
        _isLoaded = true;
        notifyListeners();
      } else {
        throw Exception("Gagal mengambil puisi.");
      }
    } catch (error) {
      rethrow;
    }
  }

  void resetCache() {
    _isLoaded = false;
    _allPuisi = [];
    notifyListeners();
  }
}
List<Karya> parsePuisiList(String responseBody) {
  final List<dynamic> parsed = json.decode(responseBody);
  return parsed.map<Karya>((json) => Karya.fromJson(json)).toList();
}
