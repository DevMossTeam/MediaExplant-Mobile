// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportModel _$ReportModelFromJson(Map<String, dynamic> json) => ReportModel(
      id: json['id'] as String,
      userId: json['user_id'] as String?,
      statusRead: json['status_read'] as String,
      status: json['status'] as String,
      detailPesan: json['detail_pesan'] as String?,
      pesanType: json['pesan_type'] as String,
      itemId: json['item_id'] as String,
    );

Map<String, dynamic> _$ReportModelToJson(ReportModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'status_read': instance.statusRead,
      'status': instance.status,
      'detail_pesan': instance.detailPesan,
      'pesan_type': instance.pesanType,
      'item_id': instance.itemId,
    };
