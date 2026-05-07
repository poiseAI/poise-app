// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_analytics_api.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$homeAnalyticsApiHash() => r'51f4ff85a6456f44f613fa2110af71af42e21574';

/// See also [homeAnalyticsApi].
@ProviderFor(homeAnalyticsApi)
final homeAnalyticsApiProvider = AutoDisposeProvider<HomeAnalyticsApi>.internal(
  homeAnalyticsApi,
  name: r'homeAnalyticsApiProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$homeAnalyticsApiHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HomeAnalyticsApiRef = AutoDisposeProviderRef<HomeAnalyticsApi>;
String _$homeAnalyticsHash() => r'0b58cc960e0a1bc5731acbbea08210f401d5441e';

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

/// See also [homeAnalytics].
@ProviderFor(homeAnalytics)
const homeAnalyticsProvider = HomeAnalyticsFamily();

/// See also [homeAnalytics].
class HomeAnalyticsFamily extends Family<AsyncValue<HomeAnalytics>> {
  /// See also [homeAnalytics].
  const HomeAnalyticsFamily();

  /// See also [homeAnalytics].
  HomeAnalyticsProvider call(
    String period,
  ) {
    return HomeAnalyticsProvider(
      period,
    );
  }

  @override
  HomeAnalyticsProvider getProviderOverride(
    covariant HomeAnalyticsProvider provider,
  ) {
    return call(
      provider.period,
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
  String? get name => r'homeAnalyticsProvider';
}

/// See also [homeAnalytics].
class HomeAnalyticsProvider extends AutoDisposeFutureProvider<HomeAnalytics> {
  /// See also [homeAnalytics].
  HomeAnalyticsProvider(
    String period,
  ) : this._internal(
          (ref) => homeAnalytics(
            ref as HomeAnalyticsRef,
            period,
          ),
          from: homeAnalyticsProvider,
          name: r'homeAnalyticsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$homeAnalyticsHash,
          dependencies: HomeAnalyticsFamily._dependencies,
          allTransitiveDependencies:
              HomeAnalyticsFamily._allTransitiveDependencies,
          period: period,
        );

  HomeAnalyticsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.period,
  }) : super.internal();

  final String period;

  @override
  Override overrideWith(
    FutureOr<HomeAnalytics> Function(HomeAnalyticsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: HomeAnalyticsProvider._internal(
        (ref) => create(ref as HomeAnalyticsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        period: period,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<HomeAnalytics> createElement() {
    return _HomeAnalyticsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HomeAnalyticsProvider && other.period == period;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, period.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin HomeAnalyticsRef on AutoDisposeFutureProviderRef<HomeAnalytics> {
  /// The parameter `period` of this provider.
  String get period;
}

class _HomeAnalyticsProviderElement
    extends AutoDisposeFutureProviderElement<HomeAnalytics>
    with HomeAnalyticsRef {
  _HomeAnalyticsProviderElement(super.provider);

  @override
  String get period => (origin as HomeAnalyticsProvider).period;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
