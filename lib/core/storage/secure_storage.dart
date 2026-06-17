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
    ]);
  }

  Future<void> saveUserId(String userId) =>
      _storage.write(key: _Keys.userId, value: userId);

  Future<String?> getUserId() => _storage.read(key: _Keys.userId);

  Future<void> clearAll() => _storage.deleteAll();
}
