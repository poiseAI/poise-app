import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/errors/app_error.dart';
import '../../../core/network/api_client.dart';
import 'exit_request_provider.dart';

part 'exit_otp_provider.freezed.dart';
part 'exit_otp_provider.g.dart';

@freezed
abstract class ExitOtpState with _$ExitOtpState {
  const factory ExitOtpState({
    @Default(false) bool isVerifying,
    @Default(false) bool wrongCode,
    @Default(false) bool success,
    String? error,
  }) = _ExitOtpState;
}

@riverpod
class ExitOtp extends _$ExitOtp {
  @override
  ExitOtpState build(String positionId) => const ExitOtpState();

  Future<void> verify(String otp) async {
    if (state.isVerifying) return;

    // Get exit request ID captured during the prior create step
    final exitRequestId = ref
        .read(exitRequestProvider(positionId))
        .exitRequestId;

    if (exitRequestId == null || exitRequestId.isEmpty) {
      state = state.copyWith(
        isVerifying: false,
        error: 'Exit request not found. Please go back and try again.',
      );
      return;
    }

    state = state.copyWith(isVerifying: true, wrongCode: false, error: null);

    try {
      final dio = ref.read(dioProvider);
      // Backend: POST /exit-requests/:id/verify-otp  { otp_code: string }
      await dio.post<void>(
        '/exit-requests/$exitRequestId/verify-otp',
        data: {'otp_code': otp},
      );
      state = state.copyWith(isVerifying: false, success: true);
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      if (statusCode == 400 || statusCode == 422) {
        state = state.copyWith(isVerifying: false, wrongCode: true);
      } else {
        final err = e.error is AppError
            ? (e.error as AppError).userMessage
            : e.message ?? 'Verification failed';
        state = state.copyWith(isVerifying: false, error: err);
      }
    }
  }

  void resetWrongCode() {
    if (state.wrongCode) state = state.copyWith(wrongCode: false);
  }
}
