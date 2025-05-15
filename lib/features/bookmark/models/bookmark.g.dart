// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmark.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bookmark _$BookmarkFromJson(Map<String, dynamic> json) => Bookmark(
      userId: json['user_id'] as String?,
      itemId: json['item_id'] as String,
      bookmarkType: json['bookmark_type'] as String,
    );

Map<String, dynamic> _$BookmarkToJson(Bookmark instance) => <String, dynamic>{
      'user_id': instance.userId,
      'item_id': instance.itemId,
      'bookmark_type': instance.bookmarkType,
    };
