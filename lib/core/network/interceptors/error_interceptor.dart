import 'package:dio/dio.dart';
import '../../errors/app_error.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final appError = _mapError(err);
    handler.next(
      err.copyWith(
        error: appError,
        message: appError.userMessage,
      ),
    );
  }

  AppError _mapError(DioException err) {
    if (err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout) {
      return const NetworkError();
    }

    final status = err.response?.statusCode;
    if (status == null) return const NetworkError();

    if (status == 401) {
      if (err.requestOptions.path.startsWith('/auth/')) {
        return ServerError(status, _extractMessage(err.response?.data));
      }
      return const UnauthorizedError();
    }

    if (status == 404) return const NotFoundError();

    if (status == 409) {
      return ServerError(status, _extractMessage(err.response?.data));
    }

    if (status == 423 || status == 429) {
      return ServerError(status, _extractMessage(err.response?.data));
    }

    if (status == 422 || status == 400) {
      final data = err.response?.data;
      if (data is Map<String, dynamic>) {
        final errors = _parseValidationErrors(data);
        if (errors.isNotEmpty) return ValidationError(errors);
        return ServerError(status, _extractMessage(data));
      }
      return const ValidationError({});
    }

    if (status >= 500) {
      return ServerError(status, _extractMessage(err.response?.data));
    }

    return UnknownError(err.message ?? '');
  }

  String _extractMessage(Object? data) {
    if (data is Map<String, dynamic>) {
      return data['message'] as String? ?? data['error'] as String? ?? '';
    }
    return '';
  }

  Map<String, List<String>> _parseValidationErrors(Map<String, dynamic> data) {
    final errors = <String, List<String>>{};

    // Gin validator format: { "field": "message" }
    if (data.containsKey('errors') && data['errors'] is Map) {
      final raw = data['errors'] as Map<String, dynamic>;
      for (final entry in raw.entries) {
        errors[entry.key] = [entry.value.toString()];
      }
    }

    return errors;
  }
}
