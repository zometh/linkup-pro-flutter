
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'splash_provider.g.dart';
@riverpod
class SplashProvider extends _$SplashProvider {
  @override
  int build() => 0;

  void next() {
    state = state < 2 ? state + 1 : 2;
  }
  void reset() {
    state = 0;
  }
  void previous() {
    state = state > 0 ? state - 1 : 0;
  }
  void  setIndex(int index) {
    if (index >= 0 && index <= 2) {
      state = index;
    }
  }

  
}