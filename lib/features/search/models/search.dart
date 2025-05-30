// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'search.g.dart';
@JsonSerializable()
class Search with ChangeNotifier {
  final String tipe;
  final String id;
  final String judul;
  final String tanggal;
  final String kategori;
  Search({
    required this.tipe,
    required this.id,
    required this.judul,
    required this.tanggal,
    required this.kategori,
  });

  factory Search.fromJson(Map<String, dynamic> json) => _$SearchFromJson(json);
  Map<String, dynamic> toJson() => _$SearchToJson(this);
}
