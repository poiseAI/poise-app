import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_response.freezed.dart';
part 'auth_response.g.dart';

Object? _readFullName(Map<dynamic, dynamic> json, String key) =>
    json['full_name'] ?? json['name'] ?? json['fullName'];

@freezed
abstract class AuthResponse with _$AuthResponse {
  const factory AuthResponse({
    required String token,
    required AuthUser user,
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
  }) = _AuthUser;

  factory AuthUser.fromJson(Map<String, dynamic> json) =>
      _$AuthUserFromJson(json);
}
