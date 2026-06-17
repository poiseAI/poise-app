import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('app runtime no longer contains the local PIN lock feature', () {
    final appSource = File('lib/app.dart').readAsStringSync();
    final storageSource =
        File('lib/core/storage/secure_storage.dart').readAsStringSync();

    expect(appSource, isNot(contains('SessionLock')));
    expect(appSource, isNot(contains('AppLockScreen')));
    expect(storageSource, isNot(contains('appPin')));
    expect(storageSource, isNot(contains('lastActiveAt')));
    expect(
      File('lib/features/auth/screens/app_lock_screen.dart').existsSync(),
      isFalse,
    );
    expect(
      File('lib/features/auth/providers/session_lock_provider.dart')
          .existsSync(),
      isFalse,
    );
  });
}
