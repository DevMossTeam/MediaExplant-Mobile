import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mediaexplant/core/network/api_client.dart';
import 'package:mediaexplant/features/home/models/karya/karya.dart';
import 'package:mediaexplant/features/home/models/produk/produk.dart';

class ProdukBookmarkRepository {
  Future<List<Produk>> fetchProdukBookmark(
      int page, int limit, String? userId) async {
    final response = await http.get(
      Uri.parse(
          "${ApiClient.baseUrl}/produk/bookmarked?page=$page&limit=$limit&user_id=$userId"),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((e) => Produk.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat Produk bookmarked');
    }
  }
}
