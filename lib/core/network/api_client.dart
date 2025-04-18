import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class ApiClient {
  final String baseUrl = "http://192.168.1.21:8000/api";

  /// GET /{endpoint}
  Future<dynamic> getData(String endpoint, {Map<String, String>? headers}) async {
    final url = Uri.parse("$baseUrl/$endpoint");
    final response = await http.get(
      url,
      headers: {
        "Accept": "application/json",
        ...?headers,
      },
    );
    return _handleResponse(response);
  }

  /// POST /{endpoint} dengan JSON body
  Future<dynamic> postData(
    String endpoint,
    Map<String, dynamic> data, {
    Map<String, String>? headers,
  }) async {
    final url = Uri.parse("$baseUrl/$endpoint");
    final response = await http.post(
      url,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        ...?headers,
      },
      body: jsonEncode(data),
    );
    return _handleResponse(response);
  }

  /// POST multipart ke /profile/update untuk upload foto profile
  Future<dynamic> uploadProfileImage({
    required String token,
    required String uid,
    required File imageFile,
  }) async {
    final uri = Uri.parse("$baseUrl/profile/update");
    final request = http.MultipartRequest('POST', uri)
      ..headers.addAll({
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      })
      ..fields['uid'] = uid
      ..files.add(
        await http.MultipartFile.fromPath(
          'profile_pic', // field name sesuai API
          imageFile.path,
        ),
      );

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);
    return _handleResponse(response);
  }

  /// POST /profile/update untuk update teks (username, nama_lengkap)
  Future<dynamic> updateProfile(
    Map<String, dynamic> data, {
    Map<String, String>? headers,
  }) async {
    return postData("profile/update", data, headers: headers);
  }

   /// Hapus foto profil via API
  Future<dynamic> deleteProfileImage({
    required String token,
    required String uid,
  }) async {
    final uri = Uri.parse("$baseUrl/profile/delete-image");
    final response = await http.post(
      uri,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"uid": uid}),
    );
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
  String toString() => "ApiException: $statusCode – $message";
}
