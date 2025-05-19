import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mediaexplant/core/network/api_client.dart';
import 'package:mediaexplant/features/home/models/produk/produk.dart';
import 'package:pdfx/pdfx.dart';

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';

class ProdukViewModel with ChangeNotifier {
  List<Produk> _allMajalah = [];
  List<Produk> _allBuletin = [];
  List<Produk> get allMajalah => _allMajalah;
  List<Produk> get allBuletin => _allBuletin;

  bool _isMajalahLoaded = false;
  bool _isBuletinLoaded = false;

  bool get isMajalahLoaded => _isMajalahLoaded;
  bool get isBuletinLoaded => _isBuletinLoaded;


  Future<void> fetchMajalah(String? userId) async {
    if (_isMajalahLoaded) return;

    final url =
        Uri.parse("${ApiClient.baseUrl}/produk-majalah?user_id=$userId");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        _allMajalah = data.map((item) => Produk.fromJson(item)).toList();

        _isMajalahLoaded = true;
        notifyListeners();

        // Proses preload thumbnail secara paralel di latar belakang
        for (final majalah in _allMajalah) {
          if (majalah.thumbnail == null) {
            preloadThumbnail(majalah); // tanpa await
          }
        }
      } else {
        throw Exception("Gagal mengambil Majalah.");
      }
    } catch (error) {
      rethrow;
    }
  }

// get buletin
  Future<void> fetchBuletin(String? userId) async {
    if (_isBuletinLoaded) return;

    final url =
        Uri.parse("${ApiClient.baseUrl}/produk-buletin?user_id=$userId");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        _allBuletin = data.map((item) => Produk.fromJson(item)).toList();

        _isBuletinLoaded = true;
        notifyListeners();

       // Proses preload thumbnail secara paralel di latar belakang
        for (final buletin in _allBuletin) {
          if (buletin.thumbnail == null) {
            preloadThumbnail(buletin); // tanpa await
          }
        }
      } else {
        throw Exception("Gagal mengambil Buletin.");
      }
    } catch (error) {
      rethrow;
    }
  }

   // Fungsi preload thumbnail
  Future<void> preloadThumbnail(Produk produk) async {
    if (produk.media_url.isEmpty) return;

    try {
      final bytes = await _fetchPdfBytes(produk.media_url);

      final document = await PdfDocument.openData(bytes);

      if (document.pagesCount < 1) {
        print('Dokumen tidak memiliki halaman');
        return;
      }

      final page = await document.getPage(1);

      final pageImage = await page.render(
        width: 300, // lebar thumbnail
        height: 400, // tinggi thumbnail
        format: PdfPageImageFormat.png,
      );

      await page.close();
      await document.close();

      if (pageImage != null && pageImage.bytes.isNotEmpty) {
        produk.thumbnail = pageImage.bytes;
      } else {
        print('Gagal render halaman PDF');
      }

      // Setelah proses selesai, hapus file PDF cache jika ada
      await clearPdfCache();
    } catch (e) {
      print('Gagal preload thumbnail: $e');
    }
    notifyListeners();
  }

  // Fungsi untuk menghapus cache file PDF
  Future<void> clearPdfCache() async {
    try {
      final cacheDir = await getTemporaryDirectory();
      final cacheFiles = Directory(cacheDir.path).listSync();

      for (var file in cacheFiles) {
        if (file is File) {
          await file.delete();
          print('Cache file deleted: ${file.path}');
        }
      }
    } catch (e) {
      print('Error while clearing PDF cache: $e');
    }
  }

  // Fungsi untuk mengunduh file PDF
  Future<Uint8List> _fetchPdfBytes(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        throw Exception('Gagal mengunduh PDF');
      }
    } catch (e) {
      print('Error downloading PDF: $e');
      rethrow;
    }
  }
// Fungsi download produk PDF
  Future<void> downloadProduk(String idProduk) async {
    final dio = Dio();
    final url = "${ApiClient.baseUrl}/produk-majalah/$idProduk/media";

    try {
      // Minta izin penyimpanan jika Android
      if (Platform.isAndroid) {
        if (!await _requestPermission()) {
          print('Izin penyimpanan ditolak');
          return;
        }
      }

      // Tentukan direktori penyimpanan
      Directory dir;
      if (Platform.isAndroid) {
        dir = await getExternalStorageDirectory() ??
            await getApplicationDocumentsDirectory();
      } else {
        dir = await getApplicationDocumentsDirectory();
      }

      final savePath = '${dir.path}/produk-$idProduk.pdf';

      // Download file
      await dio.download(
        url,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            print('Progress: ${(received / total * 100).toStringAsFixed(0)}%');
          }
        },
      );

      print('Download selesai: $savePath');

      // Buka file setelah selesai (opsional)
      await OpenFile.open(savePath);
    } catch (e) {
      print('Gagal download: $e');
    }
  }

  Future<bool> _requestPermission() async {
    final status = await Permission.storage.request();
    return status.isGranted;
  }

  void resetCache() {
    _isMajalahLoaded = false;
    _isBuletinLoaded = false;
    _allMajalah = [];
    _allBuletin = [];
    notifyListeners();
  }
}