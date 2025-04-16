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






