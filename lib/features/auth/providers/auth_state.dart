import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';

@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState.loading() = AuthLoading;

  const factory AuthState.unauthenticated() = AuthUnauthenticated;

  const factory AuthState.authenticated({
    required String userId,
    required String email,
    required String token,
    @Default('') String fullName,
    @Default(false) bool emailVerified,
    @Default(false) bool isAdmin,
    @Default(false) bool totpEnabled,
    @Default(false) bool hasActiveStrategy,
    @Default(false) bool hasExchangeConnection,
  }) = AuthAuthenticated;
}
