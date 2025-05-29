// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'detail_produk.g.dart';

@JsonSerializable()
class DetailProduk with ChangeNotifier {
  final String idproduk;
  final String? penulis;
  final String judul;
  final String cover;
  final String deskripsi;
  final String release_date;
  final String kategori;
  int jumlahLike;
  int jumlahDislike;
  int jumlahKomentar;
  bool isBookmark;
  bool isLike;
  bool isDislike;

  // // Fungsi untuk mengambil konvert media ke gambar
  @JsonKey(includeFromJson: false, includeToJson: false)
  Uint8List? _gambarBytes;
  DetailProduk({
    required this.idproduk,
    this.penulis,
    required this.judul,
    required this.cover,
    required this.deskripsi,
    required this.release_date,
    required this.kategori,
    required this.jumlahLike,
    required this.jumlahDislike,
    required this.jumlahKomentar,
    required this.isBookmark,
    required this.isLike,
    required this.isDislike,
  });

  // // Fungsi untuk mengambil konvert media ke gambar
  Uint8List gambar() {
    if (_gambarBytes == null) {
      final base64Str = cover.contains(',') ? cover.split(',').last : cover;
      _gambarBytes = base64Decode(base64Str);
    }
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

  factory DetailProduk.fromJson(Map<String, dynamic> json) =>
      _$DetailProdukFromJson(json);

  Map<String, dynamic> toJson() => _$DetailProdukToJson(this);
}
