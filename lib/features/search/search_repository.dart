import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mediaexplant/core/network/api_client.dart';
import 'package:mediaexplant/features/home/models/berita/berita.dart';

class SearchBeritaRepository {
  Future<List<Berita>> searchBerita({
    required String query,
    required int page,
    required int limit,
    String? userId,
  }) async {
    final url = Uri.parse(
      "${ApiClient.baseUrl}/berita/search?q=$query&page=$page&limit=$limit${userId != null ? '&user_id=$userId' : ''}",
    );

    final response = await http.get(url, headers: {'Accept': 'application/json'});

    if (kDebugMode) {
      print("SearchBeritaRepository response: ${response.body}");
    }

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> data = jsonResponse['data']; // sesuaikan jika berbeda
      return data.map((e) => Berita.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat hasil pencarian');
    }
  }

  Future<List<Berita>> searchByKategori({
    required String kategori,
    required int page,
    required int limit,
    String? userId,
  }) async {
    final url = Uri.parse(
      "${ApiClient.baseUrl}/berita/search/kategori?kategori=$kategori&page=$page&limit=$limit${userId != null ? '&user_id=$userId' : ''}",
    );

    final response = await http.get(url, headers: {'Accept': 'application/json'});

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> data = jsonResponse['data']; // sesuaikan jika berbeda
      return data.map((e) => Berita.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat berita berdasarkan kategori');
    }
  }
}
