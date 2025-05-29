// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detail_produk.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DetailProduk _$DetailProdukFromJson(Map<String, dynamic> json) => DetailProduk(
      idproduk: json['idproduk'] as String,
      penulis: json['penulis'] as String?,
      judul: json['judul'] as String,
      cover: json['cover'] as String,
      deskripsi: json['deskripsi'] as String,
      release_date: json['release_date'] as String,
      kategori: json['kategori'] as String,
      jumlahLike: (json['jumlahLike'] as num).toInt(),
      jumlahDislike: (json['jumlahDislike'] as num).toInt(),
      jumlahKomentar: (json['jumlahKomentar'] as num).toInt(),
      isBookmark: json['isBookmark'] as bool,
      isLike: json['isLike'] as bool,
      isDislike: json['isDislike'] as bool,
    );

Map<String, dynamic> _$DetailProdukToJson(DetailProduk instance) =>
    <String, dynamic>{
      'idproduk': instance.idproduk,
      'penulis': instance.penulis,
      'judul': instance.judul,
      'cover': instance.cover,
      'deskripsi': instance.deskripsi,
      'release_date': instance.release_date,
      'kategori': instance.kategori,
      'jumlahLike': instance.jumlahLike,
      'jumlahDislike': instance.jumlahDislike,
      'jumlahKomentar': instance.jumlahKomentar,
      'isBookmark': instance.isBookmark,
      'isLike': instance.isLike,
      'isDislike': instance.isDislike,
    };
