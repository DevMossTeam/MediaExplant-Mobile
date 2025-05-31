import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mediaexplant/core/network/api_client.dart';
import 'package:mediaexplant/features/home/models/karya/karya.dart';

class KaryaRepository {
  Future<List<Karya>> fetchKarya(String endpoint,int page, int limit, String? userId) async {
    final url = Uri.parse("${ApiClient.baseUrl}/$endpoint?page=$page&limit=$limit&user_id=$userId");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Karya.fromJson(item)).toList();
    } else {
      throw Exception("Gagal mengambil data dari endpoint: $endpoint");
    }
  }
}
   