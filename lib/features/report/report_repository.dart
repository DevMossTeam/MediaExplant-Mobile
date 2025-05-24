import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mediaexplant/core/network/api_client.dart';
import 'package:mediaexplant/features/report/report_model.dart';

class ReportRepository {
  Future<ReportModel> sendReport({
    required String? userId,
    required String pesan,
    required String statusRead,
    required String status,
    required String detailPesan,
    required String pesanType,
    required String itemId,
  }) async {
    final url = Uri.parse("${ApiClient.baseUrl}/laporan");

    final requestBody = {
      "user_id": userId,
      "pesan": pesan,
      "status_read": statusRead,
      "status": status,
      "detail_pesan": detailPesan,
      "pesan_type": pesanType,
      "item_id": itemId,
    };

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 201) {
      final data = json.decode(response.body)['data'];
      return ReportModel.fromJson(data);
    } else {
      // Tambahan log detail ketika gagal
      print("GAGAL MENGIRIM LAPORAN");
      print("URL: $url");
      print("Status Code: ${response.statusCode}");
      print("Request Body: ${jsonEncode(requestBody)}");
      print("Response Body: ${response.body}");

      throw Exception('Gagal mengirim laporan. Status: ${response.statusCode}');
    }
  }
}
