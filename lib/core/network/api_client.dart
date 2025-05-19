import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class ApiClient {
  // final String baseUrl;

  // static const String baseUrl = "https://mediaexplant.com/api";

  // static const String baseUrl = "http://192.168.1.25:8000/api";

  static const String baseUrl = "http://10.0.2.2:8000/api";

  // ApiClient({this.baseUrl = "http://192.168.1.21:8000/api"});

  /// Generic GET, sekarang bisa pakai queryParameters
  Future<Map<String, dynamic>> getData(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    // Buat Uri dengan queryParameters bila ada
    final uri = Uri.parse("$baseUrl/$endpoint").replace(
      queryParameters:
          queryParameters?.map((k, v) => MapEntry(k, v.toString())),
    );

    final resp = await http.get(
      uri,
      headers: {
        "Accept": "application/json",
        ...?headers,
      },
    );
    return _handleResponse(resp);
  }

  /// Generic POST dengan JSON body
  Future<Map<String, dynamic>> postData(
    String endpoint,
    Map<String, dynamic> data, {
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse("$baseUrl/$endpoint");
    final resp = await http.post(
      uri,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        ...?headers,
      },
      body: jsonEncode(data),
    );
    return _handleResponse(resp);
  }

  /// Upload file multipart (profile image)
  Future<Map<String, dynamic>> uploadProfileImage({
    required String token,
    required File imageFile,
  }) async {
    final uri = Uri.parse("$baseUrl/profile/update");
    final req = http.MultipartRequest('POST', uri)
      ..headers['Accept'] = 'application/json'
      ..headers['Authorization'] = 'Bearer $token'
      ..files.add(await http.MultipartFile.fromPath(
        'profile_pic',
        imageFile.path,
      ));

    final streamed = await req.send();
    final resp = await http.Response.fromStream(streamed);
    return _handleResponse(resp);
  }

  /// Hapus foto profil
  Future<Map<String, dynamic>> deleteProfileImage({
    required String token,
  }) async {
    // endpoint delete-image tidak butuh body selain token
    final uri = Uri.parse("$baseUrl/profile/delete-image");
    final resp = await http.post(
      uri,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    return _handleResponse(resp);
  }

  /// update teks pada profile
  Future<Map<String, dynamic>> updateProfile(
    Map<String, dynamic> data, {
    required String token,
  }) async {
    return postData(
      "profile/update",
      data,
      headers: {"Authorization": "Bearer $token"},
    );
  }

  /// Cek ketersediaan username sebelum simpan
  Future<bool> checkUsernameAvailability({
    required String token,
    required String username,
  }) async {
    final data = await getData(
      "profile/check-username",
      headers: {"Authorization": "Bearer $token"},
      queryParameters: {"nama_pengguna": username},
    );
    return data['available'] as bool? ?? false;
  }

  /// Handle semua response, parse JSON, lempar ApiException kalau error
  Map<String, dynamic> _handleResponse(http.Response response) {
    Map<String, dynamic> body = {};
    try {
      body = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      // jika bukan JSON valid
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    }

    // ambil message / errors
    final msg = body['message']?.toString() ??
        body['error']?.toString() ??
        response.reasonPhrase ??
        'Unknown error';
    final errors = body['errors'];

    throw ApiException(
      response.statusCode,
      msg,
      errors: errors,
    );
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String message;
  final dynamic errors; // bisa Map<String, dynamic> atau List

  ApiException(this.statusCode, this.message, {this.errors});

  @override
  String toString() {
    if (errors != null) {
      return "ApiException($statusCode): $message\nDetails: $errors";
    }
    return "ApiException($statusCode): $message";
  }
}
