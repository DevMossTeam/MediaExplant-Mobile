import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mediaexplant/core/network/api_client.dart';
import 'package:mediaexplant/features/comments/models/komentar.dart';


class KomentarViewmodel with ChangeNotifier {
  List<Komentar> _komentarList = [];
  List<Komentar> get komentarList => _komentarList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;


  Future<void> fetchKomentar({required String komentarType, required String itemId}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final url = Uri.parse("${ApiClient.baseUrl}/get-komentar?komentar_type=$komentarType&item_id=$itemId");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _komentarList = data.map((json) => Komentar.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat komentar');
      }
    } catch (e) {
      print('Error fetchKomentar: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Kirim komentar baru
  Future<bool> postKomentar({
    required String userId,
    required String isiKomentar,
    required String komentarType,
    required String itemId,
    String? parentId,
  }) async {
    final url = Uri.parse("${ApiClient.baseUrl}/komentar");

    final body = {
      'user_id': userId,
      'isi_komentar': isiKomentar,
      'komentar_type': komentarType,
      'item_id': itemId,
      'parent_id': parentId,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print('Gagal kirim komentar: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error postKomentar: $e');
      return false;
    }
  }
}
