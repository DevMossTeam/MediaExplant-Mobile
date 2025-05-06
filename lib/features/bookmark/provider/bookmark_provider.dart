
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:mediaexplant/core/network/api_client.dart';
import 'package:mediaexplant/features/bookmark/models/bookmark.dart';

class BookmarkProvider with ChangeNotifier {
  List<Bookmark> _bookmarks = [];

  List<Bookmark> get bookmarks => _bookmarks;

  // Toggle bookmark
  Future<void> toggleBookmark(Bookmark request) async {
    final url = Uri.parse("${ApiClient.baseUrl}/bookmark/toggle");

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['status'] == 'added') {
          final newBookmark = Bookmark.fromJson(responseData['data']);
          _bookmarks.add(newBookmark);
        } else if (responseData['status'] == 'removed') {
          _bookmarks.removeWhere((b) => b.itemId == request.itemId);
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
