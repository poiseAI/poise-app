import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'secure_storage.g.dart';

abstract final class _Keys {
  static const token = 'auth_token';
  static const tokenExpiresAt = 'auth_token_expires_at';
  static const sessionId = 'auth_session_id';
  static const sessionExpiresAt = 'auth_session_expires_at';
  static const userId = 'user_id';
  static const appPinHash = 'app_pin_hash';
  static const appPinSalt = 'app_pin_salt';
  static const lastActiveAt = 'app_last_active_at';
}

@Riverpod(keepAlive: true)
SecureStorageService secureStorage(Ref ref) {
  return SecureStorageService();
}

class SecureStorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  Future<void> saveToken(String token, {DateTime? expiresAt}) async {
    await _storage.write(key: _Keys.token, value: token);
    if (expiresAt != null) {
      await _storage.write(
        key: _Keys.tokenExpiresAt,
        value: expiresAt.millisecondsSinceEpoch.toString(),
      );
    }
  }

  Future<String?> getToken() => _storage.read(key: _Keys.token);

  Future<void> saveSessionId(String sessionId) =>
      _storage.write(key: _Keys.sessionId, value: sessionId);

  Future<String?> getSessionId() => _storage.read(key: _Keys.sessionId);

  Future<void> saveSessionExpiresAt(DateTime expiresAt) => _storage.write(
        key: _Keys.sessionExpiresAt,
        value: expiresAt.millisecondsSinceEpoch.toString(),
      );

  Future<DateTime?> getSessionExpiresAt() async {
    final raw = await _storage.read(key: _Keys.sessionExpiresAt);
    if (raw == null) return null;
    final ms = int.tryParse(raw);
    if (ms == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(ms);
  }

  Future<DateTime?> getTokenExpiry() async {
    final raw = await _storage.read(key: _Keys.tokenExpiresAt);
    if (raw == null) return null;
    final ms = int.tryParse(raw);
    if (ms == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(ms);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _Keys.token);
    await _storage.delete(key: _Keys.tokenExpiresAt);
  }

  Future<void> clearSession() async {
    await Future.wait([
      _storage.delete(key: _Keys.token),
      _storage.delete(key: _Keys.tokenExpiresAt),
      _storage.delete(key: _Keys.sessionId),
      _storage.delete(key: _Keys.sessionExpiresAt),
      _storage.delete(key: _Keys.userId),
      _storage.delete(key: _Keys.lastActiveAt),
    ]);
  }

  Future<void> saveUserId(String userId) =>
      _storage.write(key: _Keys.userId, value: userId);

  Future<String?> getUserId() => _storage.read(key: _Keys.userId);

  Future<void> saveAppPin({
    required String hash,
    required String salt,
  }) async {
    await Future.wait([
      _storage.write(key: _Keys.appPinHash, value: hash),
      _storage.write(key: _Keys.appPinSalt, value: salt),
    ]);
  }

  Future<({String hash, String salt})?> getAppPin() async {
    final hash = await _storage.read(key: _Keys.appPinHash);
    final salt = await _storage.read(key: _Keys.appPinSalt);
    if (hash == null || salt == null) return null;
    return (hash: hash, salt: salt);
  }

  Future<bool> hasAppPin() async => await getAppPin() != null;

  Future<void> deleteAppPin() async {
    await Future.wait([
      _storage.delete(key: _Keys.appPinHash),
      _storage.delete(key: _Keys.appPinSalt),
    ]);
  }

  Future<void> saveLastActiveAt(DateTime at) => _storage.write(
        key: _Keys.lastActiveAt,
        value: at.millisecondsSinceEpoch.toString(),
      );

  Future<DateTime?> getLastActiveAt() async {
    final raw = await _storage.read(key: _Keys.lastActiveAt);
    if (raw == null) return null;
    final ms = int.tryParse(raw);
    if (ms == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(ms);
  }

  Future<void> deleteLastActiveAt() => _storage.delete(key: _Keys.lastActiveAt);

  Future<void> clearAll() => _storage.deleteAll();
}
