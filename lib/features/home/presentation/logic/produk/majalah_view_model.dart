import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:mediaexplant/features/home/models/majalah.dart';
import 'package:pdfx/pdfx.dart';

class MajalahViewModel with ChangeNotifier {
  List<Majalah> _allMajalah = [];
  bool _isLoaded = false;

  List<Majalah> get allMajalah => _allMajalah;
  bool get isLoaded => _isLoaded;

  Future<void> fetchMajalah(String userId) async {
  if (_isLoaded) return;

  final url = Uri.parse('http://10.0.2.2:8000/api/produk-majalah?user_id=$userId');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      _allMajalah = data.map((item) => Majalah.fromJson(item)).toList();

      // Preload thumbnail untuk semua majalah
      for (final majalah in _allMajalah) {
        _preloadThumbnail(majalah);
      }

      _isLoaded = true;
      notifyListeners();
    } else {
      throw Exception("Gagal mengambil Majalah.");
    }
  } catch (error) {
    rethrow;
  }
}

Future<void> _preloadThumbnail(Majalah majalah) async {
  if (majalah.media_url.isEmpty) return;

  try {
    final data = await NetworkAssetBundle(Uri.parse(majalah.media_url)).load(majalah.media_url);
    final bytes = data.buffer.asUint8List();

    final doc = await PdfDocument.openData(bytes);
    final page = await doc.getPage(1);

    final pageImage = await page.render(
      width: 300,
      height: 400,
      format: PdfPageImageFormat.png,
    );

    await page.close();

    if (pageImage != null) {
      majalah.thumbnail = pageImage.bytes;
    }
  } catch (e) {
    debugPrint('Gagal preload thumbnail: $e');
  }
}


  void resetCache() {
    _isLoaded = false;
    _allMajalah = [];
    notifyListeners();
  }
}
