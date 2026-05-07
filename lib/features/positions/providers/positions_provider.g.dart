// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'positions_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$positionsNotifierHash() => r'854e484670b913ef4ee7ef43d24c17e409b5d125';

/// Canonical positions state — shared source of truth for home + other features.
/// Seeds from HTTP, merges WsPositionUpdate events in real time.
///
/// Copied from [PositionsNotifier].
@ProviderFor(PositionsNotifier)
final positionsNotifierProvider = AutoDisposeNotifierProvider<PositionsNotifier,
    AsyncValue<List<Position>>>.internal(
  PositionsNotifier.new,
  name: r'positionsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$positionsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PositionsNotifier = AutoDisposeNotifier<AsyncValue<List<Position>>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
