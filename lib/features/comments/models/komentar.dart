// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:json_annotation/json_annotation.dart';

part 'komentar.g.dart';

@JsonSerializable()
class Komentar {
  final String id;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'isi_komentar')
  final String isiKomentar;
  @JsonKey(name: 'tanggal_komentar')
  final String tanggalKomentar;
  @JsonKey(name: 'komentar_type')
  final String komentarType;
  @JsonKey(name: 'item_id')
  final String itemId;
  @JsonKey(name: 'parent_id')
  final String? parentId;
  @JsonKey(name: 'nama_pengguna')
  final String username;
  @JsonKey(name: 'profil_pic')
  final String? profil;
  Komentar({
    required this.id,
    required this.userId,
    required this.isiKomentar,
    required this.tanggalKomentar,
    required this.komentarType,
    required this.itemId,
    this.parentId,
    required this.username,
    this.profil,
  });
 

  factory Komentar.fromJson(Map<String, dynamic> json) =>
      _$KomentarFromJson(json);

  Map<String, dynamic> toJson() => _$KomentarToJson(this);
}
