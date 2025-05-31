import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mediaexplant/core/network/api_client.dart';
import 'package:mediaexplant/features/home/models/karya/karya.dart';

class KaryaTerkaitRepository {
  Future<List<Karya>> fetchKaryaTerkait(
      int page, int limit, String? userId, String karyaId) async {
    final url = Uri.parse(
      "${ApiClient.baseUrl}/karya/terkait?page=$page&limit=$limit&karya_id=$karyaId&user_id=$userId",
    );

    try {
      final response =
          await http.get(url, headers: {'Accept': 'application/json'});

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((e) => Karya.fromJson(e)).toList();
      } else {
        throw Exception(
            'Gagal memuat karya terkait. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat memuat karya terkait: $e');
    }
  }
}
