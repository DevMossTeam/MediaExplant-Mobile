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
  final String? username;
  @JsonKey(name: 'profil_pic')
  final String? profil;
  final List<Komentar>? childKomentar;
  Komentar({
    required this.id,
    required this.userId,
    required this.isiKomentar,
    required this.tanggalKomentar,
    required this.komentarType,
    required this.itemId,
    this.parentId,
    this.username,
    this.profil,
    this.childKomentar,
  });

  Komentar copyWith({
    String? id,
    String? userId,
    String? isiKomentar,
    String? tanggalKomentar,
    String? komentarType,
    String? itemId,
    String? parentId,
    String? username,
    String? profil,
    List<Komentar>? childKomentar,
  }) {
    return Komentar(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      isiKomentar: isiKomentar ?? this.isiKomentar,
      tanggalKomentar: tanggalKomentar ?? this.tanggalKomentar,
      komentarType: komentarType ?? this.komentarType,
      itemId: itemId ?? this.itemId,
      parentId: parentId ?? this.parentId,
      username: username ?? this.username,
      profil: profil ?? this.profil,
      childKomentar: childKomentar ?? this.childKomentar,
    );
  }

  factory Komentar.fromJson(Map<String, dynamic> json) =>
      _$KomentarFromJson(json);

  Map<String, dynamic> toJson() => _$KomentarToJson(this);
}
