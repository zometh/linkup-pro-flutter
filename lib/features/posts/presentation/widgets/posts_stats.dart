import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:linkup_pro/features/posts/presentation/providers/like_post.dart';

import '../../../../core/network/websocket/config.dart';
import '../../../../core/services/localdb/localdb.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/post.dart';

class PostsStats extends ConsumerStatefulWidget {
  final Post post;
  const PostsStats({super.key, required this.post});

  @override
  ConsumerState<PostsStats> createState() => _PostsStatsState();
}

class _PostsStatsState extends ConsumerState<PostsStats>
    with SingleTickerProviderStateMixin {
  final io = GetIt.I<SocketService>();
  final db = GetIt.I<LocalDBService>();
  late AnimationController _likeAnimController;
  bool _isLikeAnimating = false;

  @override
  void initState() {
    super.initState();
    _likeAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    io.on("likeUpdate", (callback) {
      final Map<String, dynamic> data = callback;
      updateCounter(data);
    });

    io.on("commentUpdate", (callback) {
      final Map<String, dynamic> data = callback;
      updateCommentCounter(data);
    });
  }

  @override
  void dispose() {
    _likeAnimController.dispose();
    super.dispose();
  }

  updateCounter(Map<String, dynamic> data) async {
    final userId = await db.getUserId();
    if (data["postId"] != widget.post.id) return;
    if (mounted) {
      Future.microtask(() {
        setState(() {
          widget.post.likesCount = data["likesCount"];
          if (data["userId"] == userId) {
            widget.post.isLiked = data["isLiked"];
          }
        });
      });
    }
  }

  updateCommentCounter(Map<String, dynamic> data) async {
    if (data["postId"] != widget.post.id) return;

    if (mounted) {
      Future.microtask(() {
        setState(() {
          widget.post.commentsCount = data["commentsCount"];
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        spacing: 10,
        children: [
          _buildStatButton(
            icon: widget.post.isLiked
                ? Icons.favorite_rounded
                : Icons.favorite_border_rounded,
            count: widget.post.likesCount,
            isActive: widget.post.isLiked,
            activeColor: const Color(0xFFE91E63),
            isDark: isDark,
            onTap: () {
              HapticFeedback.lightImpact();
              _triggerLikeAnimation();
              likeOrDislike();
            },
            animationController: _likeAnimController,
            isAnimating: _isLikeAnimating,
          ),

          _buildStatButton(
            icon: Icons.mode_comment_outlined,
            count: widget.post.commentsCount,
            isDark: isDark,
            onTap: () => HapticFeedback.lightImpact(),
          ),
          _buildStatButton(
            icon: Icons.share,
            count: widget.post.sharesCount,
            isDark: isDark,
            onTap: () => HapticFeedback.lightImpact(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatButton({
    required IconData icon,
    required int count,
    required bool isDark,
    VoidCallback? onTap,
    bool isActive = false,
    Color? activeColor,
    AnimationController? animationController,
    bool isAnimating = false,
  }) {
    final defaultColor = isDark
        ? Colors.white.withAlpha((0.6 * 255).round())
        : AppColors.textTertiary;
    final color = isActive ? activeColor! : defaultColor;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (animationController != null)
              AnimatedBuilder(
                animation: animationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: isAnimating
                        ? 1.0 + (animationController.value * 0.25)
                        : 1.0,
                    child: Icon(icon, size: 25, color: color),
                  );
                },
              )
            else
              Icon(icon, size: 20, color: color),
            if (count > 0) ...[
              const SizedBox(width: 6),
              Text(
                _formatCount(count),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isActive ? activeColor : defaultColor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }

  void _triggerLikeAnimation() {
    setState(() => _isLikeAnimating = true);
    _likeAnimController.forward().then((_) {
      _likeAnimController.reverse().then((_) {
        if (mounted) setState(() => _isLikeAnimating = false);
      });
    });
  }

  likeOrDislike() async {
    await ref.read(likePostProvider.notifier).likePost(widget.post.id);
  }
}
