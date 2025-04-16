// import 'package:faker/faker.dart';
// import 'package:flutter/material.dart';
// import 'package:mediaexplant/features/home/data/models/berita.dart';

// final Faker faker = Faker();

// class BeritaProvider with ChangeNotifier {
//   final List<Berita> _allBerita = List.generate(10, (index) {
//     return Berita(
//       idBerita: (index + 1).toString(),
//       judul: faker.lorem.sentence(),
//       kontenBerita: faker.lorem.sentences(3).join(' '),
//       gambar: "https://picsum.photos/id/${1 + index}/500/300",
//       tanggalDibuat: "Sabtu,22 Maret 2025 13:15 WIB",
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

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mediaexplant/features/home/data/models/berita.dart';

class BeritaProvider with ChangeNotifier {
  List<Berita> _allBerita = [];

  List<Berita> get allBerita => _allBerita;

  Future<void> fetchBerita() async {
    final url = Uri.parse('http://10.0.2.2:8000/api/berita'); // Ganti sesuai IP API kamu
    try {
      print('Fetching berita from API...'); // Debugging: Menandakan bahwa request API dimulai
      final response = await http.get(url);

      print('Response status: ${response.statusCode}'); // Debugging: Menampilkan status code dari response

      if (response.statusCode == 200) {
        print('Response body: ${response.body}'); // Debugging: Menampilkan body response untuk memastikan data yang diterima
        final List<dynamic> data = json.decode(response.body);

        _allBerita = data.map((item) => Berita.fromJson(item)).toList();

        notifyListeners();
      } else {
        throw Exception("Gagal mengambil berita. Status code: ${response.statusCode}");
      }
    } catch (error) {
      print("Terjadi kesalahan saat fetch data: $error"); // Debugging: Menampilkan error jika ada masalah saat fetch data
      rethrow;
    }
  }
}


