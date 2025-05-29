// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'berita.g.dart';

@JsonSerializable()
class Berita with ChangeNotifier {
  final String idBerita;
  final String judul;
  final String kontenBerita;
  final String tanggalDibuat;

  final String kategori;
  Berita({
    required this.idBerita,
    required this.judul,
    required this.kontenBerita,
    required this.tanggalDibuat,
    required this.kategori,
  });

  // // Fungsi untuk mengambil gambar pertama dari konten HTML
  String? get firstImageFromKonten {
    final RegExp regex = RegExp(r'<img[^>]+src="([^">]+)"');
    final match = regex.firstMatch(kontenBerita);
    return match?.group(1);
  }

  factory Berita.fromJson(Map<String, dynamic> json) => _$BeritaFromJson(json);

  Map<String, dynamic> toJson() => _$BeritaToJson(this);
}
