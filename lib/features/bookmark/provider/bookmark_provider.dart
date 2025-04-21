// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:mediaexplant/features/bookmark/models/bookmark.dart';
// import 'package:mediaexplant/features/home/data/models/berita.dart';

// class BookmarkProvider with ChangeNotifier {
//   List<Bookmark> _bookmarks = [];

//   List<Bookmark> get bookmarks => _bookmarks;

//   // Toggle bookmark
//   Future<void> toggleBookmark({
//     required String userId,
//     required String beritaId,
//     required Berita berita,
//   }) async {
//     final url = Uri.parse('http://10.0.2.2:8000/api/bookmark/toggle');

//     try {
//       final response = await http.post(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'user_id': userId,
//           'item_id': beritaId,
//           'bookmark_type': 'Berita',
//         }),
//       );

//       if (response.statusCode == 200) {
//         final responseData = json.decode(response.body);

//         if (responseData['status'] == 'added') {
//           final newBookmark = Bookmark.fromJson(responseData['data']);
//           _bookmarks.add(newBookmark);
//           berita.isBookmark = true;
//         } else if (responseData['status'] == 'removed') {
//           _bookmarks.removeWhere((b) => b.beritaId == beritaId);
//           berita.isBookmark = false;
//         }

//         berita.notifyListeners();
//         notifyListeners();
//       } else {
//         throw Exception('Gagal toggle bookmark');
//       }
//     } catch (error) {
//       print('Error toggling bookmark: $error');
//       rethrow;
//     }
//   }
// }

import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:mediaexplant/features/bookmark/models/bookmark.dart';
import 'package:mediaexplant/features/home/data/models/berita.dart';

class BookmarkProvider with ChangeNotifier {
  List<Bookmark> _bookmarks = [];

  List<Bookmark> get bookmarks => _bookmarks;

  // Toggle bookmark
  Future<void> toggleBookmark(Bookmark request) async {
    final url = Uri.parse('http://10.0.2.2:8000/api/bookmark/toggle');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),  // Menggunakan toJson dari model Bookmark
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['status'] == 'added') {
          final newBookmark = Bookmark.fromJson(responseData['data']);
          _bookmarks.add(newBookmark);
        } else if (responseData['status'] == 'removed') {
          _bookmarks.removeWhere((b) => b.beritaId == request.beritaId);
        }

        notifyListeners();
      } else {
        throw Exception('Gagal toggle bookmark: ${response.body}');
      }
    } catch (error) {
      print('Error toggling bookmark: $error');
      rethrow;
    }
  }
}
