sealed class Result<S, E> {
  const Result();

  bool get isOk => this is Ok<S, E>;
  bool get isErr => this is Err<S, E>;

  S get value => (this as Ok<S, E>).value;
  E get error => (this as Err<S, E>).error;

  S? get valueOrNull => isOk ? value : null;
  E? get errorOrNull => isErr ? error : null;

  T fold<T>({
    required T Function(S value) onOk,
    required T Function(E error) onErr,
  }) {
    return switch (this) {
      Ok<S, E>(:final value) => onOk(value),
      Err<S, E>(:final error) => onErr(error),
    };
  }

  Result<T, E> map<T>(T Function(S value) transform) {
    return switch (this) {
      Ok<S, E>(:final value) => Ok(transform(value)),
      Err<S, E>(:final error) => Err(error),
    };
  }

  Result<S, F> mapError<F>(F Function(E error) transform) {
    return switch (this) {
      Ok<S, E>(:final value) => Ok(value),
      Err<S, E>(:final error) => Err(transform(error)),
    };
  }

  Future<Result<T, E>> asyncMap<T>(
    Future<T> Function(S value) transform,
  ) async {
    return switch (this) {
      Ok<S, E>(:final value) => Ok(await transform(value)),
      Err<S, E>(:final error) => Err(error),
    };
  }
}

final class Ok<S, E> extends Result<S, E> {
  const Ok(this.value);

  @override
  final S value;
}

final class Err<S, E> extends Result<S, E> {
  const Err(this.error);

  @override
  final E error;
}
