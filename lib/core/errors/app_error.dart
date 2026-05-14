sealed class AppError {
  const AppError();

  String get userMessage => switch (this) {
        NetworkError(:final message) =>
          message.isNotEmpty ? message : 'No internet connection',
        InvalidCredentialsError() => 'Invalid credentials',
        UnauthorizedError() => 'Session expired. Please log in again.',
        ValidationError(:final fieldErrors) =>
          fieldErrors.values.expand((e) => e).firstOrNull ??
              'Please check your input',
        ServerError(:final message) =>
          message.isNotEmpty ? message : 'Server error. Please try again.',
        NotFoundError() => 'Resource not found.',
        UnknownError(:final message) =>
          message.isNotEmpty ? message : 'Something went wrong.',
      };
}

class NetworkError extends AppError {
  const NetworkError([this.message = '']);
  final String message;
}

class InvalidCredentialsError extends AppError {
  const InvalidCredentialsError();
}

class UnauthorizedError extends AppError {
  const UnauthorizedError();
}

class ValidationError extends AppError {
  const ValidationError(this.fieldErrors);
  final Map<String, List<String>> fieldErrors;

  String? fieldError(String field) => fieldErrors[field]?.firstOrNull;
}

class ServerError extends AppError {
  const ServerError(this.statusCode, [this.message = '']);
  final int statusCode;
  final String message;
}

class NotFoundError extends AppError {
  const NotFoundError();
}

class UnknownError extends AppError {
  const UnknownError([this.message = '']);
  final String message;
}
