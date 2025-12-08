import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:linkup_pro/core/network/websocket/config.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/core/widgets/custom_text.dart';
import 'package:linkup_pro/features/posts/domain/entities/post.dart';
import 'package:linkup_pro/features/posts/presentation/widgets/post_file_view.dart';
import 'package:linkup_pro/features/posts/presentation/widgets/post_header.dart';
import 'package:linkup_pro/features/posts/presentation/widgets/posts_stats.dart';
import 'package:linkup_pro/features/posts/presentation/widgets/posts_tags.dart';
import 'package:linkup_pro/features/profile/presentation/widgets/expansion_text.dart';
import 'package:linkup_pro/main.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostCard extends StatefulWidget {
  final String userId;
  final bool isPostDetails;
  final Post post;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final VoidCallback? onProfileTap;

  const PostCard({
    super.key,
    required this.post,
    required this.userId,
    this.onLike,
    this.onComment,
    this.onShare,
    this.onProfileTap,
    this.isPostDetails = false,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  String get userId => widget.userId;

  final io = GetIt.I<SocketService>();
  @override
  void initState() {
    super.initState();
    io.joinRoom("postSubscribe", {"roomId": widget.post.id});
  }

  @override
  void dispose() {
    io.joinRoom("postUnsubscribe", {"roomId": widget.post.id});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    timeago.setLocaleMessages('fr', timeago.FrShortMessages());
    timeago.setLocaleMessages('ar', timeago.ArMessages());

    final isDark = context.isDarkMode;
    final post = widget.post;

    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTap: widget.isPostDetails
              ? null
              : () {
                  if (mounted) context.push("/post/${post.id}");
                },
          child: Container(
            padding: const .symmetric(vertical: 1),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(0),
              gradient: isDark
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.darkCard,
                        AppColors.darkCard.withValues(alpha: .95),
                      ],
                    )
                  : null,
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PostHeader(post: post, userId: userId),

                ExpansionText(text: post.content),

                if (post.files.isNotEmpty) BuildPostFile(files: post.files),

                PostsStats(post: post),

                if (post.tags.isNotEmpty) PostsTags(tags: post.tags),
              ],
            ),
            //),
          ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),
        );
      },
    );
  }
}
