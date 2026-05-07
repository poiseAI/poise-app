// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationItem _$NotificationItemFromJson(Map<String, dynamic> json) =>
    _NotificationItem(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      type: json['notification_type'] as String,
      read: json['read'] as bool? ?? false,
      createdAt: json['created_at'] as String,
      meta: json['meta'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$NotificationItemToJson(_NotificationItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'notification_type': instance.type,
      'read': instance.read,
      'created_at': instance.createdAt,
      'meta': instance.meta,
    };
