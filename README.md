<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages). 
-->

funtils is a useful little dart library, that adds some nice little utilities for functional programming in dart. This library is specifically designed for dart 3+ and currently contains a Result and a Option type.

## Features

This Library contains a Result and a Option type. These are extremely useful for writing safe code in dart, as they offer several advantages over regular nulls and exceptions. Some of the advantages are a more explicit function signature and more robust code, since you wont be surprised by unexpected exceptions because the compiler forces you to deal with both cases before accessing the value.

These Types also contain some nice basic methods, like map, bind, unwrapOr, expect, etc. to make your life a lot easier and to avoid unnecessary nesting of switch expressions.

This Library is also specifically designed for dart 3+ and the Types are designed to work with darts switch expressions!

## Getting started

Adding this library is pretty straight forward! Just add the following dependency to your `pubspec.yaml`:

```yaml
dependencies:
  funtils: ^1.0.0
```

and then just run one of the following commands:

```sh
# If you just use dart:
$ dart pub get

# Or if using flutter:
$ flutter pub get
```

And with this you are ready to go!

## Usage

Here is a List of the current things that are implemented by the funtils library:

### Basic type constructs

#### Option

`Option` is a simple Algebraic Data Type that is used to represent the possibility of a missing value. It consists of 2 possible states: `Some(value)` and `None()`.

Here is a simplified implementation of this type:

```dart
sealed class Option<T> {}

final class Some<T> extends Option<T> {
  final T value;
  Some(this.value);
}

final class None<T> extends Option<T> {}
```

And here is a simple example of how to use this type:

```dart
Option<double> safeDiv(int n1, int n2) => n2 == 0 ? None() : Some(n1 / n2);

void main() {
  double result = switch (safeDiv(16, 4)) {
    Some(:final value) => value,
    None() => 0,
  };

  print(result);
}
```

#### Result

`Result` is the other big ADT. It is used to model computations, that might fail in a declarative manner. It also has, like `Option` 2 possible states: `Ok(okValue)` and `Error(errorValue)`.

Here is a simplified implementation of the Result type:

```dart
sealed class Result<T, E> {}

final class Ok<T, E> extends Result<T, E> {
    final T ok;
    Ok(this.ok);
}

final class Error<T, E> extends Result<T, E> {
    final E error;
    Error(this.error);
}
```

And here is the same division example, just with a Result instead of a Option:

```dart
Result<double, String> safeDiv(int n1, int n2) =>
    n2 == 0 ? Error("Can't divide by zero!") : Ok(n1 / n2);

void main() {
  print(switch (safeDiv(16, 4)) {
    Ok(:final ok) => ok,
    Error(:final error) => error,
  });
}
```

### Constructors

Both Option and Result have two factory constructors, to convert a nullable value or a function that might throw to a Option/Result:

```dart
factory Option.fromNullable(T? nullable);
factory Option.fromThrowable(T Function() throwable);
```

The Result variants look almost identical, with the small difference, that they take a second argument for the Error value:

```dart
factory Result.fromNullable(T? nullable, E error);
factory Result.fromThrowable(T Function() throwable, E error);
```

### Operations

Both Option and Result are Monads. This basically just means, that they have, next to their types also methods like `.flatMap()`, that allow us to alter their inner values and chain operations, without deeply nested switch expressions. This is very handy for more complex operations, as your code will turn into a simple data transformation pipeline.

Below are all of the methods of each of the types and a short explanation of what they do.

#### Option

- `Option<N> map<N>(N Function(T) fn);` Used to transform the value inside the Some of a Option.
- `Option<N> flapMap<N>(Option<N> Function(T) fn);` Used to combine two Options into one.
- `T unwrap();` Used to unwrap the value of a Option. Will throw if the Option is None!
- `T unwrapOr(T fallback);` Used to unwrap the value of a Option. Will return the fallback if the Option is a None!
- `Option<T> where(bool Function(T) fn);` Turns a Some into a None if the predicate doesn't match.

#### Result

- `Result<N, E> map<N>(N Function(T) fn);` Used to transform the value inside the Ok of a Result.
- `Result<T, N> mapError<N>(N Function(E) fn);` Used to transform the value inside the Error of a Result.
- `Result<N, E> flatMap<N>(Result<N, E> Function(T) fn);` Used to combine two Results into one. Doesn't do anything if the Result is an Error!
- `Result<T, N> flatMapError<N>(Result<T, N> Function(E) fn);` Used to combine two Results into one. Doesn't do anything if the Result is an Ok!
- `T unwrap();` Used to unwrap the value of a Result. Will throw if the Result is an Error!
- `E unwrapError();` Used to unwrap the value of a Result. Will throw if the Result is Ok!
- `T unwrapOr(T fallback);` Used to unwrap the value of a Result. Will return the fallback if the Result is an Error!
- `E unwrapErrorOr(E fallback);` Used to unwrap the value of a Result. Will return the fallback if the Result is Ok!

<!--
## Additional information

TODO: Tell users more about the package: where to find more information, how to 
contribute to the package, how to file issues, what response they can expect 
from the package authors, and more.
-->