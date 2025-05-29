// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detail_berita.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DetailBerita _$DetailBeritaFromJson(Map<String, dynamic> json) => DetailBerita(
      idBerita: json['idBerita'] as String,
      judul: json['judul'] as String,
      kontenBerita: json['kontenBerita'] as String,
      tanggalDibuat: json['tanggalDibuat'] as String,
      penulis: json['penulis'] as String,
      kategori: json['kategori'] as String,
      jumlahLike: (json['jumlahLike'] as num).toInt(),
      jumlahDislike: (json['jumlahDislike'] as num).toInt(),
      jumlahKomentar: (json['jumlahKomentar'] as num).toInt(),
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      isBookmark: json['isBookmark'] as bool,
      isLike: json['isLike'] as bool,
      isDislike: json['isDislike'] as bool,
    );

Map<String, dynamic> _$DetailBeritaToJson(DetailBerita instance) =>
    <String, dynamic>{
      'idBerita': instance.idBerita,
      'judul': instance.judul,
      'kontenBerita': instance.kontenBerita,
      'tanggalDibuat': instance.tanggalDibuat,
      'penulis': instance.penulis,
      'kategori': instance.kategori,
      'jumlahLike': instance.jumlahLike,
      'jumlahDislike': instance.jumlahDislike,
      'jumlahKomentar': instance.jumlahKomentar,
      'tags': instance.tags,
      'isBookmark': instance.isBookmark,
      'isLike': instance.isLike,
      'isDislike': instance.isDislike,
    };
