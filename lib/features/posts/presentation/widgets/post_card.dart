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
import 'package:linkup_pro/main.dart';
import 'package:timeago/timeago.dart' as timeago;



class PostCard extends StatefulWidget {
  final bool isPostDetails;
  final Post post;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final VoidCallback? onProfileTap;

  const PostCard({
    super.key,
    required this.post,
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
  bool _isExpanded = false;


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

        return InkWell(
          onTap: widget.isPostDetails ? null : () {
            // Navigate to post details page
           if(mounted)context.push("/post/${post.id}");
          },
          child: Container(
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
                // Header Section
                 PostHeader(post: post),

                // Content Section
                _buildContent(isDark),

                // Media Section (Images/Videos)
                if (post.files.isNotEmpty) BuildPostFile(files: post.files),

                // Tags Section

                // Stats Section
                PostsStats(post: post,),

                if (post.tags.isNotEmpty) PostsTags(tags: post.tags),

              ],
            ),
            //),
          ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),
        );
      },
    );
  }



  Widget _buildContent(bool isDark) {
    final content = widget.post.content;
    final shouldShowMore = content.length > 200;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedCrossFade(
            firstChild: CustomText(
              text: content,

              fontSize: 15,

              color: isDark
                  ? Colors.white.withValues(alpha: .9)
                  : AppColors.textPrimary,

              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            secondChild: CustomText(
              text: content,

              fontSize: 15,

              color: isDark
                  ? Colors.white.withValues(alpha: .9)
                  : AppColors.textPrimary,
            ),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
          if (shouldShowMore) ...[
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              child: Text(
                _isExpanded ? 'show_less'.tr() : 'show_more'.tr(),
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ],
          const SizedBox(height: 12),
        ],
      ),
    );
  }


 
}
