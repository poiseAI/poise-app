// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$notificationUnreadCountHash() =>
    r'59a8c6173f74ef8b6b67fd93e1e11c2e276100b7';

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
String _$notificationsHash() => r'c3d11cedc13fcc3fe4e80971bee186669b40db1d';

/// See also [Notifications].
@ProviderFor(Notifications)
final notificationsProvider = AutoDisposeNotifierProvider<Notifications,
    AsyncValue<List<NotificationItem>>>.internal(
  Notifications.new,
  name: r'notificationsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Notifications
    = AutoDisposeNotifier<AsyncValue<List<NotificationItem>>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
