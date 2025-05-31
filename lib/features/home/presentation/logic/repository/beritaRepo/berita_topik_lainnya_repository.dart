import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mediaexplant/core/network/api_client.dart';
import 'package:mediaexplant/features/home/models/berita/berita.dart';

class BeritaTopikLainnyaRepository {
  Future<List<Berita>> fetchBeritaTopikLainnya(
    int page,
    int limit,
    String? userId,
    String kategori,
    String beritaId,
  ) async {
    final response = await http.get(
      Uri.parse(
        "${ApiClient.baseUrl}/berita/topik-lainnya?page=$page&limit=$limit&berita_id=$beritaId&user_id=$userId&kategori=$kategori",
      ),
      headers: {'Accept': 'application/json'},
    );

    // if (kDebugMode) {
    //   print("Response status: ${response.statusCode}");
    //   print("Response body: ${response.body}");
    // }

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> data = jsonResponse['data'];

      return data.map((e) => Berita.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat berita terkait');
    }
  }
}