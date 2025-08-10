import 'package:funtils/funtils.dart';
import 'package:test/test.dart';

void main() {
  group("Option", () {
    group("constructors", () {
      test(
        "fromNullable converts a non-null to a Some",
        () => expect(Option.fromNullable(69), equals(Some(69))),
      );

      test(
        "fromNullable converts a null to a None",
        () => expect(Option<int>.fromNullable(null), equals(None<int>())),
      );

      test(
        "fromThrowable converts result to Some",
        () => expect(Option.fromThrowable(() => 420), equals(Some(420))),
      );

      test(
        "fromThrowable converts exception to None",
        () => expect(
          Option<int>.fromThrowable(
            () => throw Exception("An unexpected error occured!"),
          ),
          equals(None<int>()),
        ),
      );
    });

    group("Some operations", () {
      late Option<int> base;

      setUp(() {
        base = Some(420);
      });

      test(
        "map correctly modifies body of Some",
        () => expect(base.map((x) => x / 4), equals(Some(105.0))),
      );

      test(
        "bind executes cb and returns new Option",
        () => expect(base.flatMap((x) => Some(x / 4)), equals(Some(105.0))),
      );

      test(
        "unwrapOr returns value in Some",
        () => expect(base.unwrapOr(0), equals(420)),
      );

      test(
        "expect returns value in Some",
        () => expect(base.unwrap(), equals(420)),
      );
    });

    group("None operations", () {
      late Option<int> base;

      setUp(() {
        base = None();
      });

      test(
        "map just return None",
        () => expect(base.map((x) => x / 4), equals(None<double>())),
      );

      test(
        "bind just returns None",
        () => expect(base.flatMap((x) => Some(x / 4)), equals(None<double>())),
      );

      test("unwrapOr returns 0", () => expect(base.unwrapOr(0), equals(0)));

      test(
        "expect throws because called on None",
        () => expect(() => base.unwrap(), throwsException),
      );
    });
  });
}
