import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_item.freezed.dart';
part 'notification_item.g.dart';

enum NotificationType {
  orderFilled,
  orderCancelled,
  positionUpdate,
  riskAlert,
  system
}

@freezed
abstract class NotificationItem with _$NotificationItem {
  const factory NotificationItem({
    required String id,
    required String title,
    required String body,
    @JsonKey(name: 'notification_type') required String type,
    @Default(false) bool read,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(fromJson: _metaFromJson) Map<String, dynamic>? meta,
  }) = _NotificationItem;

  factory NotificationItem.fromJson(Map<String, dynamic> json) =>
      _$NotificationItemFromJson(json);
}

Map<String, dynamic>? _metaFromJson(Object? value) {
  if (value == null) return null;
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return value.cast<String, dynamic>();
  if (value is String && value.trim().isNotEmpty) {
    try {
      final decoded = jsonDecode(value);
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) return decoded.cast<String, dynamic>();
    } on FormatException {
      return null;
    }
  }
  return null;
}
