import 'package:funtils/funtils.dart';
import 'package:test/test.dart';

void main() {
  group("Result", () {
    group("constructors", () {
      test(
        "fromNullable converts a non-null to a Ok",
        () => expect(
          Result<int, String>.fromNullable(69, "Is null!"),
          equals(Ok<int, String>(69)),
        ),
      );

      test(
        "fromNullable converts a null to a Error",
        () => expect(
          Result<int, String>.fromNullable(null, "Is null!"),
          equals(Error<int, String>("Is null!")),
        ),
      );

      test(
        "fromThrowable converts result to Ok",
        () => expect(
          Result<int, String>.fromThrowable(() => 420, "Threw a Exception!"),
          equals(Ok<int, String>(420)),
        ),
      );

      test(
        "fromThrowable converts exception to Error",
        () => expect(
          Result<int, String>.fromThrowable(
            () => throw Exception("An unexpected error occured!"),
            "Threw a Exception!",
          ),
          equals(Error<int, String>("Threw a Exception!")),
        ),
      );
    });

    group("Ok operations", () {
      late Result<int, String> base;

      setUp(() {
        base = Ok(420);
      });

      test(
        "map correctly modifies body of Ok",
        () => expect(base.map((x) => x / 4), equals(Ok<double, String>(105.0))),
      );

      test(
        "mapError just returns the Ok",
        () => expect(
          base.mapError((e) => "Modified: $e"),
          equals(Ok<int, String>(420)),
        ),
      );

      test(
        "bind executes cb and returns new Result",
        () => expect(
          base.flatMap((x) => Ok(x / 4)),
          equals(Ok<double, String>(105.0)),
        ),
      );

      test(
        "bindError just returns the Ok",
        () => expect(
          base.flatMapError((e) => Error("Modified: $e")),
          equals(Ok<int, String>(420)),
        ),
      );

      test(
        "unwrapOr returns value in Ok",
        () => expect(base.unwrapOr(0), equals(420)),
      );

      test(
        "unwrapErrorOr returns defualt Error",
        () => expect(base.unwrapErrorOr("No Error!"), equals("No Error!")),
      );

      test(
        "expect returns value in Ok",
        () => expect(base.unwrap(), equals(420)),
      );

      test(
        "expectError throws Exception on Ok",
        () => expect(() => base.unwrapError(), throwsException),
      );
    });

    group("Error operations", () {
      late Result<int, String> base;

      setUp(() {
        base = Error("A sample error");
      });

      test(
        "map just returns the Error",
        () => expect(
          base.map((x) => x / 4),
          equals(Error<double, String>("A sample error")),
        ),
      );

      test(
        "mapError modifies the Error",
        () => expect(
          base.mapError((e) => "Modified: $e"),
          equals(Error<int, String>("Modified: A sample error")),
        ),
      );

      test(
        "bind just returns the Error",
        () => expect(
          base.flatMap((x) => Ok(x / 4)),
          equals(Error<double, String>("A sample error")),
        ),
      );

      test(
        "bindError executes cb and returns new Result",
        () => expect(
          base.flatMapError((e) => Error("Modified: $e")),
          equals(Error<int, String>("Modified: A sample error")),
        ),
      );

      test(
        "unwrapOr returns default value",
        () => expect(base.unwrapOr(0), equals(0)),
      );

      test(
        "unwrapErrorOr returns value in Error",
        () => expect(base.unwrapErrorOr("No Error!"), equals("A sample error")),
      );

      test(
        "expect throws Exception on Error",
        () => expect(() => base.unwrap(), throwsException),
      );

      test(
        "expectError just returns the value of Error",
        () => expect(base.unwrapError(), "A sample error"),
      );
    });
  });
}
