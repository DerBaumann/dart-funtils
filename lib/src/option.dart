import 'package:equatable/equatable.dart';

sealed class Option<T> extends Equatable {
  const Option();

  factory Option.fromNullable(T? nullable) => switch (nullable) {
    null => None(),
    _ => Some(nullable as T),
  };

  factory Option.fromThrowable(T Function() throwable) {
    try {
      return Some(throwable());
    } catch (_) {
      return None();
    }
  }

  @override
  List<Object?> get props => [];
}

extension OptionExt<T> on Option<T> {
  Option<N> map<N>(N Function(T) fn) => switch (this) {
    Some(:final value) => Some(fn(value)),
    None() => None(),
  };

  // >>=
  Option<N> flatMap<N>(Option<N> Function(T) fn) => switch (this) {
    Some(:final value) => fn(value),
    None() => None(),
  };

  T unwrapOr(T fallback) => switch (this) {
    Some(:final value) => value,
    None() => fallback,
  };

  T unwrap() => switch (this) {
    Some(:final value) => value,
    None() => throw Exception("Called Option.expect() on None! Expected Some!"),
  };

  Option<T> where(bool Function(T) fn) => switch (this) {
    Some(:final value) => fn(value) ? Some(value) : None(),
    None() => None(),
  };
}

final class Some<T> extends Option<T> {
  final T value;
  Some(this.value);

  @override
  List<Object?> get props => [value];
}

final class None<Nil> extends Option<Nil> {}
