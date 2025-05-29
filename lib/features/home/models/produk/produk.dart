// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'produk.g.dart';

@JsonSerializable()
class Produk with ChangeNotifier {
  final String idproduk;
  final String? penulis;
  final String judul;
  final String cover;
  final String release_date;
  final String kategori;
  @JsonKey(includeFromJson: false, includeToJson: false)
  Uint8List? _gambarBytes;
  Produk({
    required this.idproduk,
    this.penulis,
    required this.judul,
    required this.cover,
    required this.release_date,
    required this.kategori,
  });

  // // Fungsi untuk mengambil konvert media ke gambar
  Uint8List gambar() {
    if (_gambarBytes == null) {
      final base64Str = cover.contains(',') ? cover.split(',').last : cover;
      _gambarBytes = base64Decode(base64Str);
    }
    return _gambarBytes!;
  }

  factory Produk.fromJson(Map<String, dynamic> json) => _$ProdukFromJson(json);

  Map<String, dynamic> toJson() => _$ProdukToJson(this);
}
