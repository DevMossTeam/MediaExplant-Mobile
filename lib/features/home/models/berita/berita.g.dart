// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'berita.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Berita _$BeritaFromJson(Map<String, dynamic> json) => Berita(
      idBerita: json['idBerita'] as String,
      judul: json['judul'] as String,
      kontenBerita: json['kontenBerita'] as String,
      tanggalDibuat: json['tanggalDibuat'] as String,
      kategori: json['kategori'] as String,
    );

Map<String, dynamic> _$BeritaToJson(Berita instance) => <String, dynamic>{
      'idBerita': instance.idBerita,
      'judul': instance.judul,
      'kontenBerita': instance.kontenBerita,
      'tanggalDibuat': instance.tanggalDibuat,
      'kategori': instance.kategori,
    };
