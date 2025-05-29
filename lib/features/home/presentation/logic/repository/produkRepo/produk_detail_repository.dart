import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mediaexplant/core/network/api_client.dart';
import 'package:mediaexplant/features/home/models/produk/detail_produk.dart';

class ProdukDetailRepository {
  Future<DetailProduk?> fetchProdukDetail(
    String? userId,
    String produkId,
  ) async {
    final url = Uri.parse(
      "${ApiClient.baseUrl}/produk/detail?user_id=$userId&produk_id=$produkId",
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return DetailProduk.fromJson(data);
      } else {
        throw Exception("Gagal mengambil detail produk");
      }
    } catch (e) {
      rethrow;
    }
  }
}
