import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mediaexplant/core/network/api_client.dart'; 
import 'package:mediaexplant/features/home/models/berita/detail_berita.dart';

class BeritaDetailRepository {
  Future<DetailBerita> fetchBeritaDetail(
      String? userId, String idBerita) async {
    final response = await http.get(
      Uri.parse(
        "${ApiClient.baseUrl}/berita/detail?user_id=$userId&id=$idBerita",
      ),
      headers: {'Accept': 'application/json'},
    );

    // if (kDebugMode) {
    //   print("Response status: ${response.statusCode}");
    //   print("Response body: ${response.body}");
    // }

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final Map<String, dynamic> data = jsonResponse['data'];
      return DetailBerita.fromJson(data);
    } else {
      throw Exception('Failed to load berita populer');
    }
  }
}
