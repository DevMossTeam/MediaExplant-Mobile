// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'produk.g.dart';

@JsonSerializable()
class Produk with ChangeNotifier {
  final String idproduk;
  final String penulis;
  final String judul;
  final String deskripsi;
  final String release_date;
  final String kategori;
  final String? profil;
  final String media_url;
  int jumlahLike;
  int jumlahDislike;
  int jumlahKomentar;
  bool isBookmark;
  bool isLike;
  bool isDislike;
  Produk({
    required this.idproduk,
    required this.penulis,
    required this.judul,
    required this.deskripsi,
    required this.release_date,
    required this.kategori,
    this.profil,
    required this.media_url,
    required this.jumlahLike,
    required this.jumlahDislike,
    required this.jumlahKomentar,
    required this.isBookmark,
    required this.isLike,
    required this.isDislike,
  });

  Uint8List? _thumbnail;

  Uint8List? get thumbnail => _thumbnail;

  set thumbnail(Uint8List? value) {
    _thumbnail = value;
    notifyListeners();
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

  factory Produk.fromJson(Map<String, dynamic> json) =>
      _$ProdukFromJson(json);

  Map<String, dynamic> toJson() => _$ProdukToJson(this);
}
