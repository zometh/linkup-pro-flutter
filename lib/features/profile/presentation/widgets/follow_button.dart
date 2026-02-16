import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/features/profile/presentation/providers/follow_provider.dart';

class FollowButton extends ConsumerStatefulWidget {
  final String? userId;
  final bool initialIsFollowing;
  final int initialFollowersCount;
  final Function(bool isFollowing, int followersCount)? onFollowChanged;

  const FollowButton({
    super.key,
    this.userId,
    this.initialIsFollowing = false,
    this.initialFollowersCount = 0,
    this.onFollowChanged,
  });

  @override
  ConsumerState<FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends ConsumerState<FollowButton> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    // Initialize state after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_initialized && mounted && widget.userId != null) {
        ref.read(followProvider(widget.userId!).notifier).initialize(
          isFollowing: widget.initialIsFollowing,
          followersCount: widget.initialFollowersCount,
        );
        _initialized = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Si userId est null, ne rien afficher
    if (widget.userId == null) {
      return const SizedBox.shrink();
    }

    final followState = ref.watch(followProvider(widget.userId!));

    // Use initial values until provider is initialized
    final isFollowing = _initialized ? followState.isFollowing : widget.initialIsFollowing;
    final isLoading = followState.isLoading;

    return Material(
      color: isFollowing ? AppColors.primary : Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: isLoading
            ? null
            : () async {
                final newIsFollowing = await ref
                    .read(followProvider(widget.userId!).notifier)
                    .toggleFollow();

                if (widget.onFollowChanged != null) {
                  final newState = ref.read(followProvider(widget.userId!));
                  widget.onFollowChanged!(newIsFollowing, newState.followersCount);
                }
              },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isLoading)
                SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: isFollowing ? Colors.white : AppColors.primary,
                  ),
                )
              else
                Icon(
                  isFollowing
                      ? Icons.person_remove_alt_1_rounded
                      : Icons.person_add_alt_1_rounded,
                  color: isFollowing ? Colors.white : AppColors.primary,
                  size: 18,
                ),
              const SizedBox(width: 6),
              Text(
                isFollowing ? 'unfollow'.tr() : 'follow'.tr(),
                style: TextStyle(
                  color: isFollowing ? Colors.white : AppColors.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}