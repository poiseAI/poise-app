// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthResponse _$AuthResponseFromJson(Map<String, dynamic> json) =>
    _AuthResponse(
      token: json['token'] as String,
      user: AuthUser.fromJson(json['user'] as Map<String, dynamic>),
      sessionId: _readSessionId(json, 'session_id') as String?,
    );

Map<String, dynamic> _$AuthResponseToJson(_AuthResponse instance) =>
    <String, dynamic>{
      'token': instance.token,
      'user': instance.user,
      'session_id': instance.sessionId,
    };

_AuthUser _$AuthUserFromJson(Map<String, dynamic> json) => _AuthUser(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: _readFullName(json, 'full_name') as String? ?? '',
      emailVerified: json['email_verified'] as bool? ?? false,
      isAdmin: json['is_admin'] as bool? ?? false,
      totpEnabled: json['totp_enabled'] as bool? ?? false,
      hasExchangeConnection:
          _readHasExchangeConnection(json, 'has_exchange_connection')
                  as bool? ??
              false,
      subscription: json['subscription'] == null
          ? BillingSubscription.none
          : _readSubscription(json['subscription']),
    );

Map<String, dynamic> _$AuthUserToJson(_AuthUser instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'full_name': instance.fullName,
      'email_verified': instance.emailVerified,
      'is_admin': instance.isAdmin,
      'totp_enabled': instance.totpEnabled,
      'has_exchange_connection': instance.hasExchangeConnection,
      'subscription': _writeSubscription(instance.subscription),
    };
