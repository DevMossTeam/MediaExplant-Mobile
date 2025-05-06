// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'berita.g.dart';

@JsonSerializable()
class Berita with ChangeNotifier {
  final String idBerita;
  final String judul;
  final String kontenBerita;
  final String? gambar;
  final String tanggalDibuat;
  final String penulis;
  final String? profil;
  final String kategori;
  int jumlahLike;
  int jumlahDislike;
  final int jumlahKomentar;
  final List<String> tags;
  bool isBookmark;
  bool isLike;
  bool isDislike;
  Berita({
    required this.idBerita,
    required this.judul,
    required this.kontenBerita,
    this.gambar,
    required this.tanggalDibuat,
    required this.penulis,
    this.profil,
    required this.kategori,
    required this.jumlahLike,
    required this.jumlahDislike,
    required this.jumlahKomentar,
    required this.tags,
    required this.isBookmark,
    required this.isLike,
    required this.isDislike,
  });
 

  // // Fungsi untuk mengambil gambar pertama dari konten HTML
  String? get firstImageFromKonten {
    final RegExp regex = RegExp(r'<img[^>]+src="([^">]+)"');
    final match = regex.firstMatch(kontenBerita);
    return match?.group(1);
  }

  void statusBookmark() {
    isBookmark = !isBookmark;
    notifyListeners();
  }

  void statusLike() {
    if (isLike) {
      jumlahLike--;
      isLike = false;
    } else {
      jumlahLike++;
      isLike = true;

      if (isDislike) {
        jumlahDislike--;
        isDislike = false;
      }
    }
    notifyListeners();
  }

  void statusDislike() {
    if (isDislike) {
      jumlahDislike--;
      isDislike = false;
    } else {
      jumlahDislike++;
      isDislike = true;

      if (isLike) {
        jumlahLike--;
        isLike = false;
      }
    }
    notifyListeners();
  }

  factory Berita.fromJson(Map<String, dynamic> json) => _$BeritaFromJson(json);

  Map<String, dynamic> toJson() => _$BeritaToJson(this);
}
