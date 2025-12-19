import 'package:get_it/get_it.dart';
import 'package:linkup_pro/features/users/domain/user_repos_implement.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'follow_provider.g.dart';

class FollowState {
  final bool isFollowing;
  final bool isLoading;
  final int followersCount;

  const FollowState({
    this.isFollowing = false,
    this.isLoading = false,
    this.followersCount = 0,
  });

  FollowState copyWith({
    bool? isFollowing,
    bool? isLoading,
    int? followersCount,
  }) {
    return FollowState(
      isFollowing: isFollowing ?? this.isFollowing,
      isLoading: isLoading ?? this.isLoading,
      followersCount: followersCount ?? this.followersCount,
    );
  }
}

/// Provider for managing follow state for a specific user
@riverpod
class FollowNotifier extends _$FollowNotifier {
  final _repository = GetIt.I<UsersRepositoryImpl>();

  @override
  FollowState build(String userId) {
    return const FollowState();
  }

  /// Initialize state with current follow status and followers count
  void initialize({required bool isFollowing, required int followersCount}) {
    state = FollowState(
      isFollowing: isFollowing,
      followersCount: followersCount,
    );
  }

  /// Toggle follow/unfollow
  Future<bool> toggleFollow() async {
    if (state.isLoading) return state.isFollowing;

    state = state.copyWith(isLoading: true);

    final result = await _repository.followOrUnfollow(userId);

    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false);
        return state.isFollowing;
      },
      (isNowFollowing) {
        final newFollowersCount = isNowFollowing
            ? state.followersCount + 1
            : state.followersCount - 1;

        state = state.copyWith(
          isFollowing: isNowFollowing,
          isLoading: false,
          followersCount: newFollowersCount.clamp(0, double.maxFinite.toInt()),
        );
        return isNowFollowing;
      },
    );
  }
}

