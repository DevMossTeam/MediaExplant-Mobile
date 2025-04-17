import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class ApiClient {
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

Future<dynamic> uploadProfileImage({
  required String token,
  required String uid,
  required File imageFile,
}) async {
  final String endpoint = "$baseUrl/profile/update"; // POST bukan PUT
  final uri = Uri.parse(endpoint);

  final request = http.MultipartRequest('POST', uri);

  request.headers.addAll({
    "Accept": "application/json",
    "Authorization": "Bearer $token",
  });

  request.fields['uid'] = uid;

  // Perhatikan field name: harus 'profile_pic'
  request.files.add(await http.MultipartFile.fromPath('profile_pic', imageFile.path));

  final streamedResponse = await request.send();
  final response = await http.Response.fromStream(streamedResponse);

  return _handleResponse(response);
}

  /// Ganti updateProfile agar pakai POST
  Future<dynamic> updateProfile(Map<String, dynamic> data,
      {Map<String, String>? headers}) {
    return postData("profile/update", data, headers: headers);
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
