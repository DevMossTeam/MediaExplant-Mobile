import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bookmark.g.dart';

@JsonSerializable()
class Bookmark with ChangeNotifier {
  @JsonKey(name: 'user_id')
  final String? userId;
  @JsonKey(name: 'item_id')
  final String itemId;
  @JsonKey(name: 'bookmark_type')
  final String bookmarkType;
  Bookmark({
    required this.userId,
    required this.itemId,
    required this.bookmarkType,
  });

  // Factory method untuk konversi dari JSON
  factory Bookmark.fromJson(Map<String, dynamic> json) =>
      _$BookmarkFromJson(json);

  // Metode untuk mengonversi ke JSON
  Map<String, dynamic> toJson() => _$BookmarkToJson(this);
}
