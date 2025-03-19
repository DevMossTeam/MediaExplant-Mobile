// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'komentar.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Komentar _$KomentarFromJson(Map<String, dynamic> json) => Komentar(
      profileUrl: json['profileUrl'] as String,
      username: json['username'] as String,
      comment: json['comment'] as String,
      time: json['time'] as String,
      likes: (json['likes'] as num).toInt(),
      replies: (json['replies'] as num).toInt(),
    );

Map<String, dynamic> _$KomentarToJson(Komentar instance) => <String, dynamic>{
      'profileUrl': instance.profileUrl,
      'username': instance.username,
      'comment': instance.comment,
      'time': instance.time,
      'likes': instance.likes,
      'replies': instance.replies,
    };
