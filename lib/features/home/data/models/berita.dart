// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'berita.g.dart';

@JsonSerializable()
class Berita with ChangeNotifier {
  final String idBerita;
  final String judul;
  final String kontenBerita;
  final String gambar;
  final String tanggalDibuat;
  final String penulis;
  final String profil;
  final String kategori;
  final int jumlahLike;
  final int jumlahDislike;
  final int jumlahKomentar;
  bool? isBookmark;
  Berita({
    required this.idBerita,
    required this.judul,
    required this.kontenBerita,
    required this.gambar,
    required this.tanggalDibuat,
    required this.penulis,
    required this.profil,
    required this.kategori,
    required this.jumlahLike,
    required this.jumlahDislike,
    required this.jumlahKomentar,
    this.isBookmark = false,
  });

  void statusBookmark() {
    isBookmark = !(isBookmark ?? false);
    notifyListeners();
  }

  factory Berita.fromJson(Map<String, dynamic> json) => _$BeritaFromJson(json);

  Map<String, dynamic> toJson() => _$BeritaToJson(this);
}
