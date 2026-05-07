// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exit_otp_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$exitOtpHash() => r'6acaf0b526b59381d13b4631b25e347a36f7bfa6';

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

abstract class _$ExitOtp extends BuildlessAutoDisposeNotifier<ExitOtpState> {
  late final String positionId;

  ExitOtpState build(
    String positionId,
  );
}

/// See also [ExitOtp].
@ProviderFor(ExitOtp)
const exitOtpProvider = ExitOtpFamily();

/// See also [ExitOtp].
class ExitOtpFamily extends Family<ExitOtpState> {
  /// See also [ExitOtp].
  const ExitOtpFamily();

  /// See also [ExitOtp].
  ExitOtpProvider call(
    String positionId,
  ) {
    return ExitOtpProvider(
      positionId,
    );
  }

  @override
  ExitOtpProvider getProviderOverride(
    covariant ExitOtpProvider provider,
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
  String? get name => r'exitOtpProvider';
}

/// See also [ExitOtp].
class ExitOtpProvider
    extends AutoDisposeNotifierProviderImpl<ExitOtp, ExitOtpState> {
  /// See also [ExitOtp].
  ExitOtpProvider(
    String positionId,
  ) : this._internal(
          () => ExitOtp()..positionId = positionId,
          from: exitOtpProvider,
          name: r'exitOtpProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$exitOtpHash,
          dependencies: ExitOtpFamily._dependencies,
          allTransitiveDependencies: ExitOtpFamily._allTransitiveDependencies,
          positionId: positionId,
        );

  ExitOtpProvider._internal(
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
  ExitOtpState runNotifierBuild(
    covariant ExitOtp notifier,
  ) {
    return notifier.build(
      positionId,
    );
  }

  @override
  Override overrideWith(ExitOtp Function() create) {
    return ProviderOverride(
      origin: this,
      override: ExitOtpProvider._internal(
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
  AutoDisposeNotifierProviderElement<ExitOtp, ExitOtpState> createElement() {
    return _ExitOtpProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ExitOtpProvider && other.positionId == positionId;
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
mixin ExitOtpRef on AutoDisposeNotifierProviderRef<ExitOtpState> {
  /// The parameter `positionId` of this provider.
  String get positionId;
}

class _ExitOtpProviderElement
    extends AutoDisposeNotifierProviderElement<ExitOtp, ExitOtpState>
    with ExitOtpRef {
  _ExitOtpProviderElement(super.provider);

  @override
  String get positionId => (origin as ExitOtpProvider).positionId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
