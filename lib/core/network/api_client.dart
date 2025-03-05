import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiClient {
  // Android Emulator: http://10.0.2.2:8000/api
  // iOS Simulator: http://localhost:8000/api
  // Perangkat fisik: http://[IP_komputer]:8000/api
  final String baseUrl = "http://10.0.2.2:8000/api";

  Future<dynamic> getData(String endpoint, {Map<String, String>? headers}) async {
    final url = Uri.parse("$baseUrl/$endpoint");

    final response = await http.get(url, headers: {
      "Accept": "application/json",
      ...?headers,
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Gagal mendapatkan data: ${response.statusCode}");
    }
  }

  Future<dynamic> postData(String endpoint, Map<String, dynamic> data, {Map<String, String>? headers}) async {
    final url = Uri.parse("$baseUrl/$endpoint");
    final response = await http.post(url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          ...?headers,
        },
        body: jsonEncode(data));

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Gagal mengirim data: ${response.statusCode}");
    }
  }
}