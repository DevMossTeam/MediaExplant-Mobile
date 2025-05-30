import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mediaexplant/core/network/api_client.dart';
import 'package:mediaexplant/features/reaksi/models/reaksi.dart';

class ReaksiProvider with ChangeNotifier {
  Future<void> toggleReaksi(BuildContext context, Reaksi request) async {
    final url = Uri.parse("${ApiClient.baseUrl}/reaksi/toggle");

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final message = responseData['message'] ?? 'Reaksi diperbarui';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            duration: const Duration(seconds: 2),
          ),
        );

        print(message);
      } else {
        throw Exception("Gagal toggle reaksi: ${response.body}");
      }
    } catch (error) {
      print('Error toggle reaksi: $error');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Terjadi kesalahan saat toggle reaksi'),
          duration: Duration(seconds: 2),
        ),
      );

      rethrow;
    }
  }
}
