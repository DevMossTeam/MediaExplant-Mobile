import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mediaexplant/core/network/api_client.dart';
import 'package:mediaexplant/features/home/models/produk/produk.dart';

class ProdukTerkaitRopository {
  Future<List<Produk>> fetchProdukTerkait(
      int page, int limit, String? userId, String produkId) async {
    final url = Uri.parse(
      "${ApiClient.baseUrl}/produk-terkait?page=$page&limit=$limit&produk_id=$produkId&user_id=$userId",
    );

    try {
      final response =
          await http.get(url, headers: {'Accept': 'application/json'});

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((e) => Produk.fromJson(e)).toList();
      } else {
        throw Exception(
            'Gagal memuat produk terkait. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat memuat produk terkait: $e');
    }
  }
}
