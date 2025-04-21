// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:flutter/material.dart';
// import 'package:json_annotation/json_annotation.dart';

// part 'bookmark.g.dart';

// @JsonSerializable()
// class Bookmark with ChangeNotifier {
//   final String? userId;
//   @JsonKey(name: 'item_id')
//   final String? beritaId;

//   Bookmark({
//     required this.userId,
//     required this.beritaId,
//   });

//   // Factory method untuk konversi dari JSON
//   factory Bookmark.fromJson(Map<String, dynamic> json) =>
//       _$BookmarkFromJson(json);

//   // Metode untuk mengonversi ke JSON
//   Map<String, dynamic> toJson() => _$BookmarkToJson(this);
// }


// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bookmark.g.dart';

@JsonSerializable()
class Bookmark with ChangeNotifier {
  
  @JsonKey(name:'user_id')
  final String userId;
  @JsonKey(name:'item_id')
  final String beritaId;
  @JsonKey(name:'bookmark_type')
  final String bookmarkType;
  Bookmark({
    required this.userId,
    required this.beritaId,
    required this.bookmarkType,
  });

 

  // Factory method untuk konversi dari JSON
  factory Bookmark.fromJson(Map<String, dynamic> json) =>
      _$BookmarkFromJson(json);

  // Metode untuk mengonversi ke JSON
  Map<String, dynamic> toJson() => _$BookmarkToJson(this);
}


