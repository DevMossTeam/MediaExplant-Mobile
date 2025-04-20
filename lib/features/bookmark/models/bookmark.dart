// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bookmark.g.dart';

@JsonSerializable()
class Bookmark with ChangeNotifier {
  final String? id;
  final String? userId;
  @JsonKey(name: 'item_id')
  final String? beritaId;
  final String? tanggalBookmark;
  Bookmark({
    required this.id,
    required this.userId,
    required this.beritaId,
    required this.tanggalBookmark,
  });

  // Factory method untuk konversi dari JSON
  factory Bookmark.fromJson(Map<String, dynamic> json) =>
      _$BookmarkFromJson(json);

  // Metode untuk mengonversi ke JSON
  Map<String, dynamic> toJson() => _$BookmarkToJson(this);
}
