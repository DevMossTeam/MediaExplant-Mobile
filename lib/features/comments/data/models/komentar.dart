// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:json_annotation/json_annotation.dart';

part 'komentar.g.dart';

@JsonSerializable()
class Komentar {
  final String profileUrl;
  final String username;
  final String comment;
  final String time;
  final int likes;
  final int replies;
  Komentar({
    required this.profileUrl,
    required this.username,
    required this.comment,
    required this.time,
    required this.likes,
    required this.replies,
  });

  factory Komentar.fromJson(Map<String, dynamic> json) => _$KomentarFromJson(json);

  Map<String, dynamic> toJson() => _$KomentarToJson(this);
}
