import 'package:funtils/funtils.dart';

Result<double, String> safeDiv(int n1, int n2) =>
    n2 == 0 ? Error("Can't divide by zero!") : Ok(n1 / n2);

void main() {
  print(switch (safeDiv(16, 4)) {
    Ok(:final ok) => ok,
    Error(:final error) => error,
  });
}
