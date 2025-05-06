// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'karya.g.dart';

@JsonSerializable()
class Karya with ChangeNotifier {
  final String idKarya;
  final String penulis;
  final String? profil;
  final String krator;
  final String judul;
  final String deskripsi;
  final String kontenKarya;
  final String kategori;
  final String media;
  final String release;
  int jumlahLike;
  int jumlahDislike;
  final int jumlahKomentar;
  bool isBookmark;
  bool isLike;
  bool isDislike;
  Karya({
    required this.idKarya,
    required this.penulis,
    this.profil,
    required this.krator,
    required this.judul,
    required this.deskripsi,
    required this.kontenKarya,
    required this.kategori,
    required this.media,
    required this.release,
    required this.jumlahLike,
    required this.jumlahDislike,
    required this.jumlahKomentar,
    required this.isBookmark,
    required this.isLike,
    required this.isDislike,
  });

  // // Fungsi untuk mengambil konvert media ke gambar
  Uint8List? _gambarBytes;
  Uint8List gambar() {
    _gambarBytes ??= Uint8List.fromList(base64Decode(media));
    return _gambarBytes!;
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

  factory Karya.fromJson(Map<String, dynamic> json) => _$KaryaFromJson(json);

  Map<String, dynamic> toJson() => _$KaryaToJson(this);
}
