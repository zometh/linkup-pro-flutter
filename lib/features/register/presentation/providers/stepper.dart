import 'package:riverpod_annotation/riverpod_annotation.dart';


part 'stepper.g.dart';
@riverpod
class Stepper extends _$Stepper {
  @override
  int build() {
    return 0;
  }

  void goTo(int step) {
    if (step >= 0 && step < 3) {
      state = step;
    }
  }

  void next() {
    if (state < 2) {
      state++;
    }
  }

  void previous() {
    if (state > 0) {
      state--;
    }
  }
}