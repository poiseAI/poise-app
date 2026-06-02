import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/secure_storage.dart';

enum SessionLockMode { checking, unlocked, locked, setupRequired }

@immutable
class SessionLockState {
  const SessionLockState({
    required this.mode,
    this.errorText,
    this.isBusy = false,
  });

  const SessionLockState.unlocked()
      : mode = SessionLockMode.unlocked,
        errorText = null,
        isBusy = false;

  const SessionLockState.checking()
      : mode = SessionLockMode.checking,
        errorText = null,
        isBusy = true;

  const SessionLockState.locked({this.errorText, this.isBusy = false})
      : mode = SessionLockMode.locked;

  const SessionLockState.setupRequired({
    this.errorText,
    this.isBusy = false,
  }) : mode = SessionLockMode.setupRequired;

  final SessionLockMode mode;
  final String? errorText;
  final bool isBusy;

  bool get blocksApp => mode != SessionLockMode.unlocked;
  bool get needsSetup => mode == SessionLockMode.setupRequired;
}

final sessionLockProvider =
    StateNotifierProvider<SessionLockController, SessionLockState>((ref) {
  return SessionLockController(ref);
});

class SessionLockController extends StateNotifier<SessionLockState> {
  SessionLockController(this._ref) : super(const SessionLockState.unlocked());

  static const inactivityTimeout = Duration(minutes: 30);
  static const pinLength = 4;

  final Ref _ref;
  Timer? _lockTimer;
  DateTime? _lastActivityAt;
  bool _authenticated = false;

  void setAuthenticated(bool authenticated) {
    if (_authenticated == authenticated) return;
    _authenticated = authenticated;

    if (!authenticated) {
      _lockTimer?.cancel();
      _lockTimer = null;
      _lastActivityAt = null;
      state = const SessionLockState.unlocked();
      unawaited(_ref.read(secureStorageProvider).deleteLastActiveAt());
      return;
    }

    state = const SessionLockState.checking();
    unawaited(handleResumed());
  }

  void recordActivity() {
    if (!_authenticated || state.blocksApp) return;

    final now = DateTime.now();
    final lastActivityAt = _lastActivityAt;
    if (lastActivityAt != null &&
        now.difference(lastActivityAt) >= inactivityTimeout) {
      unawaited(_requirePinOrSetup());
      return;
    }

    _lastActivityAt = now;
    _scheduleLockTimer();
  }

  Future<void> markInactive() async {
    if (!_authenticated) return;

    final now = DateTime.now();
    final lastActivityAt = _lastActivityAt ?? now;
    await _ref.read(secureStorageProvider).saveLastActiveAt(lastActivityAt);
    _lockTimer?.cancel();
  }

  Future<void> handleResumed() async {
    if (!_authenticated ||
        (state.blocksApp && state.mode != SessionLockMode.checking)) {
      return;
    }

    final now = DateTime.now();
    final DateTime? storedLastActiveAt;
    try {
      storedLastActiveAt =
          await _ref.read(secureStorageProvider).getLastActiveAt();
    } on Object {
      await _requirePinOrSetup();
      return;
    }
    if (!_authenticated) return;

    final lastActiveAt = _earliest(_lastActivityAt, storedLastActiveAt);

    if (lastActiveAt != null &&
        now.difference(lastActiveAt) >= inactivityTimeout) {
      await _requirePinOrSetup();
      return;
    }

    final hasPin = await _hasAppPin();
    if (!_authenticated) return;
    if (!hasPin) {
      state = const SessionLockState.setupRequired();
      return;
    }

    await _markUnlocked();
  }

  Future<bool> unlockWithPin(String pin) async {
    if (!_isValidPin(pin)) {
      state = const SessionLockState.locked(
        errorText: 'Enter your 4-digit PIN',
      );
      return false;
    }

    state = const SessionLockState.locked(isBusy: true);
    final ({String hash, String salt})? saved;
    try {
      saved = await _ref.read(secureStorageProvider).getAppPin();
    } on Object {
      if (!_authenticated) return false;
      state = const SessionLockState.locked(
        errorText: 'Unable to verify PIN. Try again.',
      );
      return false;
    }
    if (!_authenticated) return false;

    if (saved == null) {
      state = const SessionLockState.setupRequired();
      return false;
    }

    final hash = _hashPin(pin, saved.salt);
    if (hash != saved.hash) {
      state = const SessionLockState.locked(errorText: 'Incorrect PIN');
      return false;
    }

    await _markUnlocked();
    return true;
  }

  Future<bool> setupPin({
    required String pin,
    required String confirmPin,
  }) async {
    if (!_isValidPin(pin)) {
      state = const SessionLockState.setupRequired(
        errorText: 'Choose a 4-digit PIN',
      );
      return false;
    }
    if (pin != confirmPin) {
      state = const SessionLockState.setupRequired(
        errorText: 'PINs do not match',
      );
      return false;
    }

    state = const SessionLockState.setupRequired(isBusy: true);
    final salt = _newSalt();
    try {
      await _ref.read(secureStorageProvider).saveAppPin(
            hash: _hashPin(pin, salt),
            salt: salt,
          );
    } on Object {
      if (!_authenticated) return false;
      state = const SessionLockState.setupRequired(
        errorText: 'Unable to save PIN. Try again.',
      );
      return false;
    }
    if (!_authenticated) return false;

    await _markUnlocked();
    return true;
  }

  void clearError() {
    if (state.errorText == null || state.isBusy) return;
    state = switch (state.mode) {
      SessionLockMode.locked => const SessionLockState.locked(),
      SessionLockMode.setupRequired => const SessionLockState.setupRequired(),
      SessionLockMode.checking => const SessionLockState.checking(),
      SessionLockMode.unlocked => const SessionLockState.unlocked(),
    };
  }

  Future<void> clearPin() => _ref.read(secureStorageProvider).deleteAppPin();

  Future<void> _requirePinOrSetup() async {
    if (!_authenticated) return;

    _lockTimer?.cancel();
    final hasPin = await _hasAppPin();
    if (!_authenticated) return;

    state = hasPin
        ? const SessionLockState.locked()
        : const SessionLockState.setupRequired();
  }

  Future<bool> _hasAppPin() async {
    try {
      return await _ref.read(secureStorageProvider).hasAppPin();
    } on Object {
      return false;
    }
  }

  Future<void> _markUnlocked() async {
    _lastActivityAt = DateTime.now();
    if (!_authenticated) return;

    state = const SessionLockState.unlocked();
    _scheduleLockTimer();
    try {
      await _ref.read(secureStorageProvider).deleteLastActiveAt();
    } on Object {
      // Storage cleanup should not strand an otherwise valid session.
    }
  }

  void _scheduleLockTimer() {
    _lockTimer?.cancel();
    _lockTimer =
        Timer(inactivityTimeout, () => unawaited(_requirePinOrSetup()));
  }

  bool _isValidPin(String pin) {
    return pin.length == pinLength && RegExp(r'^\d{4}$').hasMatch(pin);
  }

  String _hashPin(String pin, String salt) {
    return sha256.convert(utf8.encode('$salt:$pin')).toString();
  }

  String _newSalt() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    return base64UrlEncode(bytes);
  }

  DateTime? _earliest(DateTime? a, DateTime? b) {
    if (a == null) return b;
    if (b == null) return a;
    return a.isBefore(b) ? a : b;
  }

  @override
  void dispose() {
    _lockTimer?.cancel();
    super.dispose();
  }
}
