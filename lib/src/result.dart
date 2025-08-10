import 'package:equatable/equatable.dart';

sealed class Result<T, E> extends Equatable {
  const Result();

  factory Result.fromNullable(T? nullable, E error) => switch (nullable) {
    null => Error(error),
    _ => Ok(nullable as T),
  };

  factory Result.fromThrowable(T Function() throwable, E error) {
    try {
      return Ok(throwable());
    } catch (_) {
      return Error(error);
    }
  }

  @override
  List<Object?> get props => [];
}

extension ResultExt<T, E> on Result<T, E> {
  Result<N, E> map<N>(N Function(T) fn) => switch (this) {
    Ok(:final ok) => Ok(fn(ok)),
    Error(:final error) => Error(error),
  };

  Result<T, N> mapError<N>(N Function(E) fn) => switch (this) {
    Ok(:final ok) => Ok(ok),
    Error(:final error) => Error(fn(error)),
  };

  // >>=
  Result<N, E> flatMap<N>(Result<N, E> Function(T) fn) => switch (this) {
    Ok(:final ok) => fn(ok),
    Error(:final error) => Error(error),
  };

  Result<T, N> flatMapError<N>(Result<T, N> Function(E) fn) => switch (this) {
    Ok(:final ok) => Ok(ok),
    Error(:final error) => fn(error),
  };

  T unwrapOr(T fallback) => switch (this) {
    Ok(:final ok) => ok,
    Error() => fallback,
  };

  E unwrapErrorOr(E fallback) => switch (this) {
    Ok() => fallback,
    Error(:final error) => error,
  };

  T unwrap() => switch (this) {
    Ok(:final ok) => ok,
    Error(:final error) => throw Exception(
      "Called Result.expect() on Error($error)! Expected Ok!",
    ),
  };

  E unwrapError() => switch (this) {
    Ok(:final ok) => throw Exception(
      "Called Result.expectError() on Ok($ok)! Expected Error!",
    ),
    Error(:final error) => error,
  };
}

final class Ok<T, Nil> extends Result<T, Nil> {
  final T ok;
  Ok(this.ok);

  @override
  List<Object?> get props => [ok];
}

final class Error<Nil, E> extends Result<Nil, E> {
  final E error;
  Error(this.error);

  @override
  List<Object?> get props => [error];
}
