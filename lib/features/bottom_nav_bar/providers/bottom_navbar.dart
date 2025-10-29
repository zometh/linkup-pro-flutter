
import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';


part 'bottom_navbar.g.dart';

@Riverpod()
class BottomNavbar extends _$BottomNavbar {
  @override
  int build() {
    return 0;
  }
  setIndex(int index) {
    state = index;
  }
}

// Provider simple pour gérer la visibilité du bottom navbar lors du scroll
final bottomNavbarVisibilityProvider = StateProvider<bool>((ref) => true);
