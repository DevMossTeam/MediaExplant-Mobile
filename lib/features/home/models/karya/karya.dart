// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'karya.g.dart';

@JsonSerializable()
class Karya with ChangeNotifier {
  final String idKarya;
  final String judul;
  final String kategori;
  final String media;
  final String release;
  

  // // Fungsi untuk mengambil konvert media ke gambar
  Uint8List? _gambarBytes;
  Karya({
    required this.idKarya,
    required this.judul,
    required this.kategori,
    required this.media,
    required this.release,
  });
  Uint8List gambar() {
    _gambarBytes ??= Uint8List.fromList(base64Decode(media));
    return _gambarBytes!;
  }

  // fungsi untuk kategori

  String get kategoriFormatted {
    switch (kategori.toLowerCase()) {
      case 'syair':
        return 'Syair';
      case 'desain_grafis':
        return 'Desain grafis';
      case 'puisi':
        return 'Puisi';
      case 'pantun':
        return 'Pantun';
      case 'fotografi':
        return 'Fotografi';
      default:
        return kategori;
    }
  }


  factory Karya.fromJson(Map<String, dynamic> json) => _$KaryaFromJson(json);

  Map<String, dynamic> toJson() => _$KaryaToJson(this);
}
