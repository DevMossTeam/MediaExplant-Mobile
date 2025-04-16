import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class ApiClient {
  // Ganti dengan alamat backend Laravel sesuai dengan environment
  // Emulator Android: http://10.0.2.2:8000/api
  // Simulator iOS / perangkat fisik: http://localhost:8000/api atau http://[IP_komputer]:8000/api
  final String baseUrl = "http://192.168.1.21:8000/api";

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

  /// Tambahan method: Update profil melalui API.
  /// Misalnya, endpoint untuk update adalah "profile/update"
  Future<dynamic> updateProfile(Map<String, dynamic> data, {Map<String, String>? headers}) async {
    // Ganti endpoint sesuai dengan API Anda
    final String endpoint = "profile/update";
    return await putData(endpoint, data, headers: headers);
  }

  /// Tambahan method: Upload foto profil.
  /// Menggunakan multipart request untuk meng-upload file gambar.
  Future<dynamic> uploadProfileImage({
    required String token,
    required String uid,
    required File imageFile,
  }) async {
    // Ganti endpoint sesuai API backend yang meng-handle upload image
    final String endpoint = "$baseUrl/profile/upload-image";
    final uri = Uri.parse(endpoint);

    // Buat request multipart
    final request = http.MultipartRequest('POST', uri);

    // Set header: gunakan token untuk otorisasi jika diperlukan
    request.headers.addAll({
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    });

    // Tambahkan field UID (jika diperlukan)
    request.fields['uid'] = uid;

    // Tambahkan file gambar
    request.files.add(await http.MultipartFile.fromPath('profile_image', imageFile.path));

    // Kirim request
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

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