import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mediaexplant/core/network/api_client.dart';
import 'package:mediaexplant/features/home/models/karya/detail_karya.dart';

class KaryaDetailRepository {
  Future<DetailKarya?> fetchKaryaDetail(
    String? userId,
    String karyaId,
  ) async {
    final url = Uri.parse(
      "${ApiClient.baseUrl}/karya/detail?user_id=$userId&karya_id=$karyaId",
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return DetailKarya.fromJson(data);
      } else {
        throw Exception("Gagal mengambil detail produk");
      }
    } catch (e) {
      rethrow;
    }
  }
}
