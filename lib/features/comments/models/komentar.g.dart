// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'komentar.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Komentar _$KomentarFromJson(Map<String, dynamic> json) => Komentar(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      isiKomentar: json['isi_komentar'] as String,
      tanggalKomentar: json['tanggal_komentar'] as String,
      komentarType: json['komentar_type'] as String,
      itemId: json['item_id'] as String,
      parentId: json['parent_id'] as String?,
      username: json['nama_pengguna'] as String,
      profil: json['profil_pic'] as String?,
    );

Map<String, dynamic> _$KomentarToJson(Komentar instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'isi_komentar': instance.isiKomentar,
      'tanggal_komentar': instance.tanggalKomentar,
      'komentar_type': instance.komentarType,
      'item_id': instance.itemId,
      'parent_id': instance.parentId,
      'nama_pengguna': instance.username,
      'profil_pic': instance.profil,
    };
