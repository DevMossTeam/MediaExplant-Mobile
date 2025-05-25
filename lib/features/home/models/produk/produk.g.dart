// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'produk.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Produk _$ProdukFromJson(Map<String, dynamic> json) => Produk(
      idproduk: json['idproduk'] as String,
      penulis: json['penulis'] as String?,
      judul: json['judul'] as String,
      deskripsi: json['deskripsi'] as String,
      release_date: json['release_date'] as String,
      kategori: json['kategori'] as String,
      profil: json['profil'] as String?,
      media_url: json['media_url'] as String,
      jumlahLike: (json['jumlahLike'] as num).toInt(),
      jumlahDislike: (json['jumlahDislike'] as num).toInt(),
      jumlahKomentar: (json['jumlahKomentar'] as num).toInt(),
      isBookmark: json['isBookmark'] as bool,
      isLike: json['isLike'] as bool,
      isDislike: json['isDislike'] as bool,
    );

Map<String, dynamic> _$ProdukToJson(Produk instance) => <String, dynamic>{
      'idproduk': instance.idproduk,
      'penulis': instance.penulis,
      'judul': instance.judul,
      'deskripsi': instance.deskripsi,
      'release_date': instance.release_date,
      'kategori': instance.kategori,
      'profil': instance.profil,
      'media_url': instance.media_url,
      'jumlahLike': instance.jumlahLike,
      'jumlahDislike': instance.jumlahDislike,
      'jumlahKomentar': instance.jumlahKomentar,
      'isBookmark': instance.isBookmark,
      'isLike': instance.isLike,
      'isDislike': instance.isDislike,
    };
