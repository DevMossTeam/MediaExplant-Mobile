// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reaksi.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reaksi _$ReaksiFromJson(Map<String, dynamic> json) => Reaksi(
      userId: json['user_id'] as String,
      beritaId: json['item_id'] as String,
      jenisReaksi: json['jenis_reaksi'] as String,
      reaksiType: json['reaksi_type'] as String,
    );

Map<String, dynamic> _$ReaksiToJson(Reaksi instance) => <String, dynamic>{
      'user_id': instance.userId,
      'item_id': instance.beritaId,
      'jenis_reaksi': instance.jenisReaksi,
      'reaksi_type': instance.reaksiType,
    };
