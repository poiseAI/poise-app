import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_response.freezed.dart';
part 'auth_response.g.dart';

Object? _readFullName(Map<dynamic, dynamic> json, String key) =>
    json['full_name'] ?? json['name'] ?? json['fullName'];

Object? _readHasExchangeConnection(Map<dynamic, dynamic> json, String key) =>
    json['has_exchange_connection'] ??
    json['exchange_setup_complete'] ??
    json['hasExchangeConnection'];

Object? _readSessionId(Map<dynamic, dynamic> json, String key) =>
    json['session_id'] ?? json['sessionId'];

@freezed
abstract class AuthResponse with _$AuthResponse {
  const factory AuthResponse({
    required String token,
    required AuthUser user,
    @JsonKey(name: 'session_id', readValue: _readSessionId) String? sessionId,
  }) = _AuthResponse;

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);
}

@freezed
abstract class AuthUser with _$AuthUser {
  const factory AuthUser({
    required String id,
    required String email,
    @Default('')
    @JsonKey(name: 'full_name', readValue: _readFullName)
    String fullName,
    @Default(false) @JsonKey(name: 'email_verified') bool emailVerified,
    @Default(false) @JsonKey(name: 'is_admin') bool isAdmin,
    @Default(false) @JsonKey(name: 'totp_enabled') bool totpEnabled,
    @Default(false)
    @JsonKey(
      name: 'has_exchange_connection',
      readValue: _readHasExchangeConnection,
    )
    bool hasExchangeConnection,
  }) = _AuthUser;

  factory AuthUser.fromJson(Map<String, dynamic> json) =>
      _$AuthUserFromJson(json);
}
