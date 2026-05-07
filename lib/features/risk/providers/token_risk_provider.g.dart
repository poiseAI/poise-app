// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_risk_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$tokenRiskHash() => r'61b15a01fafefb8b7e49f2b18f449ce2d3732610';

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

/// See also [tokenRisk].
@ProviderFor(tokenRisk)
const tokenRiskProvider = TokenRiskFamily();

/// See also [tokenRisk].
class TokenRiskFamily extends Family<AsyncValue<RiskScore>> {
  /// See also [tokenRisk].
  const TokenRiskFamily();

  /// See also [tokenRisk].
  TokenRiskProvider call(
    String symbol,
  ) {
    return TokenRiskProvider(
      symbol,
    );
  }

  @override
  TokenRiskProvider getProviderOverride(
    covariant TokenRiskProvider provider,
  ) {
    return call(
      provider.symbol,
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
  String? get name => r'tokenRiskProvider';
}

/// See also [tokenRisk].
class TokenRiskProvider extends AutoDisposeFutureProvider<RiskScore> {
  /// See also [tokenRisk].
  TokenRiskProvider(
    String symbol,
  ) : this._internal(
          (ref) => tokenRisk(
            ref as TokenRiskRef,
            symbol,
          ),
          from: tokenRiskProvider,
          name: r'tokenRiskProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$tokenRiskHash,
          dependencies: TokenRiskFamily._dependencies,
          allTransitiveDependencies: TokenRiskFamily._allTransitiveDependencies,
          symbol: symbol,
        );

  TokenRiskProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.symbol,
  }) : super.internal();

  final String symbol;

  @override
  Override overrideWith(
    FutureOr<RiskScore> Function(TokenRiskRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TokenRiskProvider._internal(
        (ref) => create(ref as TokenRiskRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        symbol: symbol,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<RiskScore> createElement() {
    return _TokenRiskProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TokenRiskProvider && other.symbol == symbol;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, symbol.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TokenRiskRef on AutoDisposeFutureProviderRef<RiskScore> {
  /// The parameter `symbol` of this provider.
  String get symbol;
}

class _TokenRiskProviderElement
    extends AutoDisposeFutureProviderElement<RiskScore> with TokenRiskRef {
  _TokenRiskProviderElement(super.provider);

  @override
  String get symbol => (origin as TokenRiskProvider).symbol;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
