// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$notificationUnreadCountHash() =>
    r'589b1d279f02dbafa8d389086979c85bdb00830f';

/// See also [notificationUnreadCount].
@ProviderFor(notificationUnreadCount)
final notificationUnreadCountProvider = AutoDisposeProvider<int>.internal(
  notificationUnreadCount,
  name: r'notificationUnreadCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationUnreadCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NotificationUnreadCountRef = AutoDisposeProviderRef<int>;
String _$notificationsHash() => r'f963936253f7b0aa256287f793666671c78ea809';

/// See also [Notifications].
@ProviderFor(Notifications)
final notificationsProvider =
    AutoDisposeNotifierProvider<Notifications, List<NotificationItem>>.internal(
  Notifications.new,
  name: r'notificationsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Notifications = AutoDisposeNotifier<List<NotificationItem>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
