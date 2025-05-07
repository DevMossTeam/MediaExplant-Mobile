import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:mediaexplant/core/network/api_client.dart';
import 'package:mediaexplant/features/home/models/karya/karya.dart';

class DesainGrafisViewmodel with ChangeNotifier {
  List<Karya> _allDesainGrafis = [];
  bool _isLoaded = false;

  List<Karya> get allDesainGrafis => _allDesainGrafis;
  bool get isLoaded => _isLoaded;

  Future<void> fetchDesainGrafis(String userId) async {
    if (_isLoaded) return;

    final url =
        Uri.parse("${ApiClient.baseUrl}/desain-grafis/terbaru?user_id=$userId");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _allDesainGrafis = data.map((item) => Karya.fromJson(item)).toList();
        _isLoaded = true;
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }

  void resetCache() {
    _isLoaded = false;
    _allDesainGrafis = [];
    notifyListeners();
  }
}
