// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detail_karya.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DetailKarya _$DetailKaryaFromJson(Map<String, dynamic> json) => DetailKarya(
      idKarya: json['idKarya'] as String,
      penulis: json['penulis'] as String?,
      profil: json['profil'] as String?,
      krator: json['krator'] as String,
      judul: json['judul'] as String,
      deskripsi: json['deskripsi'] as String,
      kontenKarya: json['kontenKarya'] as String,
      kategori: json['kategori'] as String,
      media: json['media'] as String,
      release: json['release'] as String,
      jumlahLike: (json['jumlahLike'] as num).toInt(),
      jumlahDislike: (json['jumlahDislike'] as num).toInt(),
      jumlahKomentar: (json['jumlahKomentar'] as num).toInt(),
      isBookmark: json['isBookmark'] as bool,
      isLike: json['isLike'] as bool,
      isDislike: json['isDislike'] as bool,
    );

Map<String, dynamic> _$DetailKaryaToJson(DetailKarya instance) =>
    <String, dynamic>{
      'idKarya': instance.idKarya,
      'penulis': instance.penulis,
      'profil': instance.profil,
      'krator': instance.krator,
      'judul': instance.judul,
      'deskripsi': instance.deskripsi,
      'kontenKarya': instance.kontenKarya,
      'kategori': instance.kategori,
      'media': instance.media,
      'release': instance.release,
      'jumlahLike': instance.jumlahLike,
      'jumlahDislike': instance.jumlahDislike,
      'jumlahKomentar': instance.jumlahKomentar,
      'isBookmark': instance.isBookmark,
      'isLike': instance.isLike,
      'isDislike': instance.isDislike,
    };
