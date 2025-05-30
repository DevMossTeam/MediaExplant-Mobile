// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'karya.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Karya _$KaryaFromJson(Map<String, dynamic> json) => Karya(
      idKarya: json['idKarya'] as String,
      judul: json['judul'] as String,
      kategori: json['kategori'] as String,
      media: json['media'] as String,
      release: json['release'] as String,
    );

Map<String, dynamic> _$KaryaToJson(Karya instance) => <String, dynamic>{
      'idKarya': instance.idKarya,
      'judul': instance.judul,
      'kategori': instance.kategori,
      'media': instance.media,
      'release': instance.release,
    };
