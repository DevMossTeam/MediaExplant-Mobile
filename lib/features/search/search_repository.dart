import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mediaexplant/core/network/api_client.dart';
import 'package:mediaexplant/features/search/models/search.dart';

class SearchRepository {
  Future<List<Search>> search(String keyword) async {
    try {
      final response = await http.get(Uri.parse("${ApiClient.baseUrl}/search?katakunci=$keyword"));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => Search.fromJson(e)).toList();
      } else {
        throw Exception('Gagal memuat hasil pencarian');
      }
    } catch (e) {
      throw Exception('Error saat memuat hasil pencarian: $e');
    }
  }
}
