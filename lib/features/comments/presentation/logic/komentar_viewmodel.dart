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

  /// Untuk menyimpan komentar yang sedang dibalas
  String? _replyToKomentarId;
  String? _replyToUsername;

  String? get replyToKomentarId => _replyToKomentarId;
  String? get replyToUsername => _replyToUsername;

  /// Set komentar yang sedang dibalas
  void setReplyTo({required String komentarId, required String username}) {
    _replyToKomentarId = komentarId;
    _replyToUsername = username;
    notifyListeners();
  }

  /// Reset balasan
  void clearReplyTo() {
    _replyToKomentarId = null;
    _replyToUsername = null;
    notifyListeners();
  }

  Future<void> fetchKomentar(
      {required String komentarType, required String itemId}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final url = Uri.parse(
          "${ApiClient.baseUrl}/get-komentar?komentar_type=$komentarType&item_id=$itemId");
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

  Future<bool> postKomentar({
    required String? userId,
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

  Future<bool> deleteKomentar(String komentarId) async {
    final url =
        Uri.parse("${ApiClient.baseUrl}/delete-komentar?id=$komentarId");

    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        _komentarList.removeWhere((komentar) => komentar.id == komentarId);
        notifyListeners();
        return true;
      } else {
        print('Gagal hapus komentar: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error deleteKomentar: $e');
      return false;
    }
  }
}
