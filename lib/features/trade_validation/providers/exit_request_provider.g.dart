// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exit_request_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$exitReasonsHash() => r'4c760f55d7b36364ada3a13400ad3b48badd71d6';

/// See also [exitReasons].
@ProviderFor(exitReasons)
final exitReasonsProvider =
    AutoDisposeFutureProvider<List<ExitReason>>.internal(
  exitReasons,
  name: r'exitReasonsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$exitReasonsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ExitReasonsRef = AutoDisposeFutureProviderRef<List<ExitReason>>;
String _$exitRequestHash() => r'decbe1bfac8fcb7508780255251a971dedbe8672';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$ExitRequest
    extends BuildlessAutoDisposeNotifier<ExitRequestState> {
  late final String positionId;

  ExitRequestState build(
    String positionId,
  );
}

/// See also [ExitRequest].
@ProviderFor(ExitRequest)
const exitRequestProvider = ExitRequestFamily();

/// See also [ExitRequest].
class ExitRequestFamily extends Family<ExitRequestState> {
  /// See also [ExitRequest].
  const ExitRequestFamily();

  /// See also [ExitRequest].
  ExitRequestProvider call(
    String positionId,
  ) {
    return ExitRequestProvider(
      positionId,
    );
  }

  @override
  ExitRequestProvider getProviderOverride(
    covariant ExitRequestProvider provider,
  ) {
    return call(
      provider.positionId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'exitRequestProvider';
}

/// See also [ExitRequest].
class ExitRequestProvider
    extends AutoDisposeNotifierProviderImpl<ExitRequest, ExitRequestState> {
  /// See also [ExitRequest].
  ExitRequestProvider(
    String positionId,
  ) : this._internal(
          () => ExitRequest()..positionId = positionId,
          from: exitRequestProvider,
          name: r'exitRequestProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$exitRequestHash,
          dependencies: ExitRequestFamily._dependencies,
          allTransitiveDependencies:
              ExitRequestFamily._allTransitiveDependencies,
          positionId: positionId,
        );

  ExitRequestProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.positionId,
  }) : super.internal();

  final String positionId;

  @override
  ExitRequestState runNotifierBuild(
    covariant ExitRequest notifier,
  ) {
    return notifier.build(
      positionId,
    );
  }

  @override
  Override overrideWith(ExitRequest Function() create) {
    return ProviderOverride(
      origin: this,
      override: ExitRequestProvider._internal(
        () => create()..positionId = positionId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        positionId: positionId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<ExitRequest, ExitRequestState>
      createElement() {
    return _ExitRequestProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ExitRequestProvider && other.positionId == positionId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, positionId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ExitRequestRef on AutoDisposeNotifierProviderRef<ExitRequestState> {
  /// The parameter `positionId` of this provider.
  String get positionId;
}

class _ExitRequestProviderElement
    extends AutoDisposeNotifierProviderElement<ExitRequest, ExitRequestState>
    with ExitRequestRef {
  _ExitRequestProviderElement(super.provider);

  @override
  String get positionId => (origin as ExitRequestProvider).positionId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
