import 'package:flutter_riverpod/legacy.dart';

final unreadConversationsCountProvider =
    StateNotifierProvider<UnreadConversationsNotifier, int>((ref) {
      return UnreadConversationsNotifier();
    });

class UnreadConversationsNotifier extends StateNotifier<int> {
  UnreadConversationsNotifier() : super(0);

  void updateCount(int count) {
    state = count;
  }

  void increment() {
    state++;
  }

  void decrement() {
    if (state > 0) {
      state--;
    }
  }

  void reset() {
    state = 0;
  }
}
