import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:mediaexplant/core/network/api_client.dart';
import 'package:mediaexplant/features/home/models/karya/karya.dart';

class FotografiViewmodel with ChangeNotifier {
  List<Karya> _allFotografi = [];
  bool _isLoaded = false;

  List<Karya> get allFotografi => _allFotografi;
  bool get siLoaded => _isLoaded;

  Future<void> fetchFotografi(String? userId) async {
    if (_isLoaded) return;
    final url = Uri.parse("${ApiClient.baseUrl}/fotografi/terbaru?user_id=$userId");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        _allFotografi = data.map((Item) => Karya.fromJson(Item)).toList();
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
    _allFotografi = [];
    notifyListeners();
  }
}
