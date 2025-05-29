// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'detail_berita.g.dart';

@JsonSerializable()
class DetailBerita with ChangeNotifier {
  final String idBerita;
  final String judul;
  final String kontenBerita;
  final String tanggalDibuat;
  final String penulis;
  final String kategori;
  int jumlahLike;
  int jumlahDislike;
  final int jumlahKomentar;
  final List<String> tags;
  bool isBookmark;
  bool isLike;
  bool isDislike;
  DetailBerita({
    required this.idBerita,
    required this.judul,
    required this.kontenBerita,
    required this.tanggalDibuat,
    required this.penulis,
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

  factory DetailBerita.fromJson(Map<String, dynamic> json) =>
      _$DetailBeritaFromJson(json);

  Map<String, dynamic> toJson() => _$DetailBeritaToJson(this);
}
