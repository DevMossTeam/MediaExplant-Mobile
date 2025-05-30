// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Search _$SearchFromJson(Map<String, dynamic> json) => Search(
      tipe: json['tipe'] as String,
      id: json['id'] as String,
      judul: json['judul'] as String,
      tanggal: json['tanggal'] as String,
      kategori: json['kategori'] as String,
    );

Map<String, dynamic> _$SearchToJson(Search instance) => <String, dynamic>{
      'tipe': instance.tipe,
      'id': instance.id,
      'judul': instance.judul,
      'tanggal': instance.tanggal,
      'kategori': instance.kategori,
    };
