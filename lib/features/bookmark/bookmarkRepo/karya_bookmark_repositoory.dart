import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mediaexplant/core/network/api_client.dart';
import 'package:mediaexplant/features/home/models/karya/karya.dart';

class KaryaBookmarkRepository {
  Future<List<Karya>> fetchKaryaBookmark(
      int page, int limit, String? userId) async {
    final response = await http.get(
      Uri.parse(
          "${ApiClient.baseUrl}/karya/bookmarked?page=$page&limit=$limit&user_id=$userId"),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((e) => Karya.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat karya bookmarked');
    }
  }
}
