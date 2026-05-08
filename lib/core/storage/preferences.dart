import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'preferences.g.dart';

@Riverpod(keepAlive: true)
Future<AppPreferences> appPreferences(Ref ref) async {
  final prefs = await SharedPreferences.getInstance();
  return AppPreferences(prefs);
}

class AppPreferences {
  AppPreferences(this._prefs);

  final SharedPreferences _prefs;

  static const _themeKey = 'theme_mode';
  static const _onboardingCompleteKey = 'onboarding_complete';
  static const _hasSeenWelcomeKey = 'has_seen_welcome';
  static const _notifPermAskedKey = 'notif_perm_asked';
  static const _notifTradeUpdatesKey = 'notif_trade_updates';
  static const _notifGuardrailsKey = 'notif_guardrails';
  static const _notifExternalTradesKey = 'notif_external_trades';
  static const _notifEmailKey = 'notif_email';

  ThemeMode get themeMode {
    final raw = _prefs.getString(_themeKey);
    return switch (raw) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    await _prefs.setString(_themeKey, value);
  }

  bool get isOnboardingComplete =>
      _prefs.getBool(_onboardingCompleteKey) ?? false;

  Future<void> setOnboardingComplete() =>
      _prefs.setBool(_onboardingCompleteKey, true);

  bool get hasSeenWelcome => _prefs.getBool(_hasSeenWelcomeKey) ?? false;

  Future<void> setHasSeenWelcome() =>
      _prefs.setBool(_hasSeenWelcomeKey, true);

  bool get notifPermissionAsked =>
      _prefs.getBool(_notifPermAskedKey) ?? false;

  Future<void> setNotifPermissionAsked() =>
      _prefs.setBool(_notifPermAskedKey, true);

  bool get tradeUpdateNotifications =>
      _prefs.getBool(_notifTradeUpdatesKey) ?? true;

  Future<void> setTradeUpdateNotifications(bool value) =>
      _prefs.setBool(_notifTradeUpdatesKey, value);

  bool get guardrailNotifications =>
      _prefs.getBool(_notifGuardrailsKey) ?? true;

  Future<void> setGuardrailNotifications(bool value) =>
      _prefs.setBool(_notifGuardrailsKey, value);

  bool get externalTradeNotifications =>
      _prefs.getBool(_notifExternalTradesKey) ?? true;

  Future<void> setExternalTradeNotifications(bool value) =>
      _prefs.setBool(_notifExternalTradesKey, value);

  bool get emailNotifications => _prefs.getBool(_notifEmailKey) ?? false;

  Future<void> setEmailNotifications(bool value) =>
      _prefs.setBool(_notifEmailKey, value);
}
