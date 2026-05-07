import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_item.freezed.dart';
part 'notification_item.g.dart';

enum NotificationType { orderFilled, orderCancelled, positionUpdate, riskAlert, system }

@freezed
abstract class NotificationItem with _$NotificationItem {
  const factory NotificationItem({
    required String id,
    required String title,
    required String body,
    @JsonKey(name: 'notification_type') required String type,
    @Default(false) bool read,
    @JsonKey(name: 'created_at') required String createdAt,
    Map<String, dynamic>? meta,
  }) = _NotificationItem;

  factory NotificationItem.fromJson(Map<String, dynamic> json) =>
      _$NotificationItemFromJson(json);
}
