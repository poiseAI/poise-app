import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poise_ai/core/storage/secure_storage.dart';
import 'package:poise_ai/features/auth/providers/session_lock_provider.dart';

void main() {
  test('setupPin stores local hash and unlockWithPin validates it', () async {
    final storage = _FakeSecureStorage();
    final container = ProviderContainer(
      overrides: [secureStorageProvider.overrideWithValue(storage)],
    );
    addTearDown(container.dispose);

    final controller = container.read(sessionLockProvider.notifier);
    controller.setAuthenticated(true);
    await Future<void>.delayed(Duration.zero);

    expect(
      await controller.setupPin(pin: '1234', confirmPin: '5678'),
      isFalse,
    );
    expect(container.read(sessionLockProvider).mode,
        SessionLockMode.setupRequired);

    expect(
      await controller.setupPin(pin: '1234', confirmPin: '1234'),
      isTrue,
    );
    expect(storage.savedPin, isNotNull);
    expect(container.read(sessionLockProvider).mode, SessionLockMode.unlocked);

    expect(await controller.unlockWithPin('1111'), isFalse);
    expect(container.read(sessionLockProvider).mode, SessionLockMode.locked);
    expect(container.read(sessionLockProvider).errorText, 'Incorrect PIN');

    expect(await controller.unlockWithPin('1234'), isTrue);
    expect(container.read(sessionLockProvider).mode, SessionLockMode.unlocked);
  });

  test('setAuthenticated checks saved inactivity timestamp', () async {
    final storage = _FakeSecureStorage()
      ..lastActiveAt = DateTime.now().subtract(const Duration(minutes: 31));
    final container = ProviderContainer(
      overrides: [secureStorageProvider.overrideWithValue(storage)],
    );
    addTearDown(container.dispose);

    container.read(sessionLockProvider.notifier).setAuthenticated(true);
    await Future<void>.delayed(Duration.zero);

    expect(
      container.read(sessionLockProvider).mode,
      SessionLockMode.setupRequired,
    );
  });

  test('setAuthenticated requires setup when no PIN exists', () async {
    final storage = _FakeSecureStorage();
    final container = ProviderContainer(
      overrides: [secureStorageProvider.overrideWithValue(storage)],
    );
    addTearDown(container.dispose);

    container.read(sessionLockProvider.notifier).setAuthenticated(true);

    expect(container.read(sessionLockProvider).mode, SessionLockMode.checking);

    await Future<void>.delayed(Duration.zero);

    expect(
      container.read(sessionLockProvider).mode,
      SessionLockMode.setupRequired,
    );
  });

  test('setAuthenticated unlocks after a fresh session check with saved PIN',
      () async {
    final storage = _FakeSecureStorage()
      ..savedPin = (hash: 'saved-hash', salt: 'saved-salt');
    final container = ProviderContainer(
      overrides: [secureStorageProvider.overrideWithValue(storage)],
    );
    addTearDown(container.dispose);

    container.read(sessionLockProvider.notifier).setAuthenticated(true);

    expect(container.read(sessionLockProvider).mode, SessionLockMode.checking);

    await Future<void>.delayed(Duration.zero);

    expect(container.read(sessionLockProvider).mode, SessionLockMode.unlocked);
  });

  test('pending resume check is ignored after sign out', () async {
    final storage = _FakeSecureStorage()
      ..lastActiveAtCompleter = Completer<DateTime?>();
    final container = ProviderContainer(
      overrides: [secureStorageProvider.overrideWithValue(storage)],
    );
    addTearDown(container.dispose);

    final controller = container.read(sessionLockProvider.notifier);
    controller.setAuthenticated(true);

    expect(container.read(sessionLockProvider).mode, SessionLockMode.checking);

    controller.setAuthenticated(false);
    storage.lastActiveAtCompleter!.complete(
      DateTime.now().subtract(const Duration(minutes: 31)),
    );
    await Future<void>.delayed(Duration.zero);

    expect(container.read(sessionLockProvider).mode, SessionLockMode.unlocked);
  });

  test('storage cleanup failure does not keep fresh session checking',
      () async {
    final storage = _FakeSecureStorage()
      ..savedPin = (hash: 'saved-hash', salt: 'saved-salt')
      ..throwOnDeleteLastActiveAt = true;
    final container = ProviderContainer(
      overrides: [secureStorageProvider.overrideWithValue(storage)],
    );
    addTearDown(container.dispose);

    container.read(sessionLockProvider.notifier).setAuthenticated(true);
    await Future<void>.delayed(Duration.zero);

    expect(container.read(sessionLockProvider).mode, SessionLockMode.unlocked);
  });

  test('last activity read failure exits checking conservatively', () async {
    final storage = _FakeSecureStorage()..throwOnGetLastActiveAt = true;
    final container = ProviderContainer(
      overrides: [secureStorageProvider.overrideWithValue(storage)],
    );
    addTearDown(container.dispose);

    container.read(sessionLockProvider.notifier).setAuthenticated(true);
    await Future<void>.delayed(Duration.zero);

    expect(
      container.read(sessionLockProvider).mode,
      SessionLockMode.setupRequired,
    );
  });

  test('app pin read failure exits checking conservatively', () async {
    final storage = _FakeSecureStorage()
      ..lastActiveAt = DateTime.now().subtract(const Duration(minutes: 31))
      ..throwOnGetAppPin = true;
    final container = ProviderContainer(
      overrides: [secureStorageProvider.overrideWithValue(storage)],
    );
    addTearDown(container.dispose);

    container.read(sessionLockProvider.notifier).setAuthenticated(true);
    await Future<void>.delayed(Duration.zero);

    expect(
      container.read(sessionLockProvider).mode,
      SessionLockMode.setupRequired,
    );
  });

  test('setupPin save failure stays in setup mode with an error', () async {
    final storage = _FakeSecureStorage()..throwOnSaveAppPin = true;
    final container = ProviderContainer(
      overrides: [secureStorageProvider.overrideWithValue(storage)],
    );
    addTearDown(container.dispose);

    final controller = container.read(sessionLockProvider.notifier);
    controller.setAuthenticated(true);
    await Future<void>.delayed(Duration.zero);

    expect(
      await controller.setupPin(pin: '1234', confirmPin: '1234'),
      isFalse,
    );
    expect(
      container.read(sessionLockProvider).mode,
      SessionLockMode.setupRequired,
    );
    expect(
      container.read(sessionLockProvider).errorText,
      'Unable to save PIN. Try again.',
    );
  });

  test('unlockWithPin read failure stays locked with an error', () async {
    final storage = _FakeSecureStorage()..throwOnGetAppPin = true;
    final container = ProviderContainer(
      overrides: [secureStorageProvider.overrideWithValue(storage)],
    );
    addTearDown(container.dispose);

    final controller = container.read(sessionLockProvider.notifier);
    controller.setAuthenticated(true);
    await Future<void>.delayed(Duration.zero);
    await controller.setupPin(pin: '1234', confirmPin: '1234');

    storage.throwOnGetAppPin = true;
    expect(await controller.unlockWithPin('1234'), isFalse);
    expect(container.read(sessionLockProvider).mode, SessionLockMode.locked);
    expect(
      container.read(sessionLockProvider).errorText,
      'Unable to verify PIN. Try again.',
    );
  });
}

class _FakeSecureStorage extends SecureStorageService {
  ({String hash, String salt})? savedPin;
  DateTime? lastActiveAt;
  Completer<DateTime?>? lastActiveAtCompleter;
  bool throwOnDeleteLastActiveAt = false;
  bool throwOnGetAppPin = false;
  bool throwOnGetLastActiveAt = false;
  bool throwOnSaveAppPin = false;

  @override
  Future<void> saveAppPin({
    required String hash,
    required String salt,
  }) async {
    if (throwOnSaveAppPin) {
      throw StateError('app pin save unavailable');
    }
    savedPin = (hash: hash, salt: salt);
  }

  @override
  Future<({String hash, String salt})?> getAppPin() async {
    if (throwOnGetAppPin) {
      throw StateError('app pin unavailable');
    }
    return savedPin;
  }

  @override
  Future<DateTime?> getLastActiveAt() async {
    if (throwOnGetLastActiveAt) {
      throw StateError('last activity unavailable');
    }
    final completer = lastActiveAtCompleter;
    if (completer != null) return completer.future;
    return Future.value(lastActiveAt);
  }

  @override
  Future<void> deleteLastActiveAt() async {
    if (throwOnDeleteLastActiveAt) {
      throw StateError('last activity cleanup unavailable');
    }
  }
}
