import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mediaexplant/core/network/api_client.dart';
import 'package:mediaexplant/features/home/models/produk/produk.dart';


class ProdukRepository {
  Future<List<Produk>> fetchMajalah(String? userId) async {
    final url = Uri.parse("${ApiClient.baseUrl}/produk-majalah?user_id=$userId");

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Produk.fromJson(item)).toList();
    } else {
      throw Exception("Gagal mengambil Majalah.");
    }
  }

  Future<List<Produk>> fetchBuletin(String? userId) async {
    final url = Uri.parse("${ApiClient.baseUrl}/produk-buletin?user_id=$userId");

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Produk.fromJson(item)).toList();
    } else {
      throw Exception("Gagal mengambil Buletin.");
    }
  }
}
