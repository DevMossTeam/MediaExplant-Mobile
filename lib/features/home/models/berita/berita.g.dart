// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'berita.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Berita _$BeritaFromJson(Map<String, dynamic> json) => Berita(
      idBerita: json['idBerita'] as String,
      judul: json['judul'] as String,
      kontenBerita: json['kontenBerita'] as String,
      gambar: json['gambar'] as String?,
      tanggalDibuat: json['tanggalDibuat'] as String,
      penulis: json['penulis'] as String?,
      profil: json['profil'] as String?,
      kategori: json['kategori'] as String,
      jumlahLike: (json['jumlahLike'] as num).toInt(),
      jumlahDislike: (json['jumlahDislike'] as num).toInt(),
      jumlahKomentar: (json['jumlahKomentar'] as  num).toInt(),
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      isBookmark: json['isBookmark'] as bool,
      isLike: json['isLike'] as bool,
      isDislike: json['isDislike'] as bool,
    );

Map<String, dynamic> _$BeritaToJson(Berita instance) => <String, dynamic>{
      'idBerita': instance.idBerita,
      'judul': instance.judul,
      'kontenBerita': instance.kontenBerita,
      'gambar': instance.gambar,
      'tanggalDibuat': instance.tanggalDibuat,
      'penulis': instance.penulis,
      'profil': instance.profil,
      'kategori': instance.kategori,
      'jumlahLike': instance.jumlahLike,
      'jumlahDislike': instance.jumlahDislike,
      'jumlahKomentar': instance.jumlahKomentar,
      'tags': instance.tags,
      'isBookmark': instance.isBookmark,
      'isLike': instance.isLike,
      'isDislike': instance.isDislike,
    };
