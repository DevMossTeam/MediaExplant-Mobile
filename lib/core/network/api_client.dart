import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiClient {
  // Ganti dengan alamat backend Laravel sesuai dengan environment
  // Emulator Android: http://10.0.2.2:8000/api
  // Simulator iOS / perangkat fisik: http://localhost:8000/api atau http://[IP_komputer]:8000/api
  final String baseUrl = "http://192.168.1.21:8000/api";
  // final String baseUrl = "http://192.168.1.46:8000/api";
  Future<dynamic> getData(String endpoint, {Map<String, String>? headers}) async {
    final url = Uri.parse("$baseUrl/$endpoint");

    final response = await http.get(url, headers: {
      "Accept": "application/json",
      ...?headers,
    });

    return _handleResponse(response);
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

    return _handleResponse(response);
  }

  Future<dynamic> putData(String endpoint, Map<String, dynamic> data, {Map<String, String>? headers}) async {
    final url = Uri.parse("$baseUrl/$endpoint");

    final response = await http.put(url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          ...?headers,
        },
        body: jsonEncode(data));

    return _handleResponse(response);
  }

  Future<dynamic> deleteData(String endpoint, {Map<String, String>? headers}) async {
    final url = Uri.parse("$baseUrl/$endpoint");

    final response = await http.delete(url, headers: {
      "Accept": "application/json",
      ...?headers,
    });

    return _handleResponse(response);
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw ApiException(response.statusCode, response.body);
    }
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String message;

  ApiException(this.statusCode, this.message);

  @override
  String toString() {
    return "ApiException: $statusCode - $message";
  }
}