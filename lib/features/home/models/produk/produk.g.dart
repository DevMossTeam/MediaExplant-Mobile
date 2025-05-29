// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'produk.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Produk _$ProdukFromJson(Map<String, dynamic> json) => Produk(
      idproduk: json['idproduk'] as String,
      penulis: json['penulis'] as String?,
      judul: json['judul'] as String,
      cover: json['cover'] as String,
      release_date: json['release_date'] as String,
      kategori: json['kategori'] as String,
    );

Map<String, dynamic> _$ProdukToJson(Produk instance) => <String, dynamic>{
      'idproduk': instance.idproduk,
      'penulis': instance.penulis,
      'judul': instance.judul,
      'cover': instance.cover,
      'release_date': instance.release_date,
      'kategori': instance.kategori,
    };
