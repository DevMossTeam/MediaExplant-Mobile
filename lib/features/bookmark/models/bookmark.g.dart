// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmark.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bookmark _$BookmarkFromJson(Map<String, dynamic> json) => Bookmark(
      id: json['id'] as String?,
      userId: json['userId'] as String?,
      beritaId: json['beritaId'] as String?,
      tanggalBookmark: json['tanggalBookmark'] as String?,
    );

Map<String, dynamic> _$BookmarkToJson(Bookmark instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'beritaId': instance.beritaId,
      'tanggalBookmark': instance.tanggalBookmark,
    };
