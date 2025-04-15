// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../models/berita.dart';

// abstract class NewsRemoteDataSource {
//   Future<List<Berita>> fetchAllBerita();
// }

// class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
//   final http.Client client;

//   NewsRemoteDataSourceImpl({required this.client});

//   @override
//   Future<List<Berita>> fetchAllBerita() async {
//     final response = await client.get(
//       Uri.parse('http://127.0.0.1:8000/api/berita'),
//       headers: {'Content-Type': 'application/json'},
//     );

//     if (response.statusCode == 200) {
//       final List<dynamic> jsonList = json.decode(response.body);
//       return jsonList.map((json) => Berita.fromJson(json)).toList();
//     } else {
//       throw Exception('Gagal memuat berita');
//     }
//   }
// }
