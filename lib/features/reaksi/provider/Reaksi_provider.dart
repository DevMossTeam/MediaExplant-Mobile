import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:mediaexplant/features/reaksi/models/reaksi.dart';

class ReaksiProvider with ChangeNotifier {
  Future<void> toggleReaksi(Reaksi request) async {
    final url = Uri.parse("http://10.0.2.2:8000/api/reaksi/toggle");

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if(response.statusCode == 200){
       print("Reaksi berhasil di-toggle");
    }else{
       throw Exception("Gagal toggle reaksi: ${response.body}");
    }
  }
}
