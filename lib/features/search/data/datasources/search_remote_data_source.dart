import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/search_model.dart';

abstract class SearchRemoteDataSource {
  Future<List<SearchModel>> performSearch(String query);
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final http.Client client;

  SearchRemoteDataSourceImpl({required this.client});

  @override
  Future<List<SearchModel>> performSearch(String query) async {
    // Ganti URL dengan endpoint API pencarian Anda
    final url = Uri.parse("https://example.com/api/search?q=$query");
    final response = await client.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList
          .map((jsonItem) => SearchModel.fromJson(jsonItem))
          .toList();
    } else {
      throw Exception("Failed to perform search");
    }
  }
}