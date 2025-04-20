import 'dart:convert';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mediaexplant/features/home/data/models/berita.dart';


// nyambung API

class BeritaTerkiniViewmodel with ChangeNotifier {
  List<Berita> _allBerita = [];
  bool _isLoaded = false;

  List<Berita> get allBerita => _allBerita;
  bool get isLoaded => _isLoaded;

  Future<void> getBerita() async {
    if (_isLoaded) return; // Jangan get lagi kalau sudah ada datanya

    final url = Uri.parse('http://10.0.2.2:8000/api/berita');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _allBerita = data.map((item) => Berita.fromJson(item)).toList();
        _isLoaded = true; 
        notifyListeners();
      } else {
        throw Exception("Gagal mengambil berita.");
      }
    } catch (error) {
      rethrow;
    }
  }

  void resetCache() {
    _isLoaded = false;
    _allBerita = [];
    notifyListeners();
  }
}






// menggunakan data faker


// final Faker faker = Faker();

// class BeritaTerkiniViewmodel with ChangeNotifier {
//   final List<Berita> _allBerita = List.generate(10, (index) {
//     return Berita(
//       idBerita: (index + 1).toString(),
//       judul: faker.lorem.sentence(),
//       kontenBerita: faker.lorem.sentences(3).join(' '),
//       gambar: "https://picsum.photos/id/${1 + index}/500/300",
//       tanggalDibuat: "7 Dec 2024",
//       penulis: faker.person.name(),
//       profil: "https://picsum.photos/id/2/500/300",
//       kategori: "Teknologi",
//       jumlahLike: 0,
//       jumlahDislike: 0,
//       jumlahKomentar: 81,
//       tags: List.generate(
//         faker.randomGenerator
//             .integer(8, min: 4), // Jumlah tag antara 2 sampai 5
//         (i) => faker.lorem.word(), // Generate random kata sebagai tag
//       ),
//       isLike: false,
//       isDislike: false,
//     );
//   });

//   List<Berita> get allBerita {
//     return _allBerita;
//   }
// }
