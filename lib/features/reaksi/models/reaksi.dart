// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reaksi.g.dart';

@JsonSerializable()
class Reaksi with ChangeNotifier {
  @JsonKey(name:'user_id')
  final String userId;
  @JsonKey(name:'item_id')
  final String itemId;
  @JsonKey(name:'jenis_reaksi')
  final String jenisReaksi;
  @JsonKey(name:'reaksi_type')
  final String reaksiType;
  Reaksi({
    required this.userId,
    required this.itemId,
    required this.jenisReaksi,
    required this.reaksiType,
  });


  // Factory method untuk konversi dari JSON
  factory Reaksi.fromJson(Map<String, dynamic> json) => _$ReaksiFromJson(json);

  // Metode untuk mengonversi ke JSON
  Map<String, dynamic> toJson() => _$ReaksiToJson(this);
}
