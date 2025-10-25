import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:linkup_pro/core/enums/user_role.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/core/widgets/custom_text.dart';
import 'package:linkup_pro/features/posts/domain/entities/company_post.dart';
import 'package:linkup_pro/features/posts/domain/entities/member_post.dart';
import 'package:linkup_pro/features/posts/domain/entities/post.dart';
import 'package:linkup_pro/features/posts/presentation/widgets/image_previw.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostCard extends StatefulWidget {
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
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _isExpanded = false;
  bool _isLiked = false;
  int _currentImageIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final post = widget.post;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;

        return Card(
          margin: EdgeInsets.symmetric(
            horizontal: maxWidth * 0.02,
            vertical: 8,
          ),
          elevation: isDark ? 4 : 2,
          shadowColor: Colors.black26,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
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
              color: isDark ? null : AppColors.lightSurface,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                _buildHeader(isDark),

                // Content Section
                _buildContent(isDark),

                // Media Section (Images/Videos)
                if (post.files.isNotEmpty) _buildMediaSection(),

                // Tags Section
                if (post.tags.isNotEmpty) _buildTagsSection(isDark),

                // Stats Section
                _buildStatsSection(isDark),

                const Divider(height: 1),

                // Action Buttons
                _buildActionButtons(isDark),
              ],
            ),
          ),
        ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0);
      },
    );
  }

  Widget _buildHeader(bool isDark) {
    final owner = widget.post.owner;
    final isCompany = owner.role == UserRole.entreprise;

    String displayName;
    String? avatarUrl;

    if (isCompany) {
      final companyData = owner.owner as CompanyPost;
      displayName = companyData.name;
      avatarUrl = companyData.logo;
    } else {
      final memberData = owner.owner as MemberPost;
      displayName = '${memberData.firstName} ${memberData.lastName}';
      avatarUrl = memberData.photo;
    }

    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Avatar
          GestureDetector(
            onTap: widget.onProfileTap,
            child: Hero(
              tag: 'avatar_${widget.post.id}',
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: avatarUrl == null
                      ? AppGradients.primaryGradient
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 0,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.transparent,
                  backgroundImage: avatarUrl != null
                      ? CachedNetworkImageProvider(avatarUrl)
                      : null,
                  child: avatarUrl == null
                      ? CustomText(
                          text: displayName[0].toUpperCase(),

                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          fontFamily: "Poppins",
                        )
                      : null,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: CustomText(
                        text:
                            displayName[0].toUpperCase() +
                            displayName.substring(1),

                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isDark ? Colors.white : AppColors.textPrimary,
                        fontFamily: "Manrope",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isCompany) ...[
                      const SizedBox(width: 4),
                      Icon(Icons.verified, size: 18, color: AppColors.primary),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: .1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CustomText(
                        text: owner.sector.tr(),

                        fontSize: 8,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Poppins",
                      ),
                    ),
                    const SizedBox(width: 8),
                    CustomText(
                      text: timeago.format(
                        widget.post.publicationDate,
                        locale: context.locale.languageCode,
                      ),

                      fontSize: 11,
                      color: isDark ? Colors.white60 : AppColors.textSecondary,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // More Options Button
          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: isDark ? Colors.white70 : AppColors.textSecondary,
            ),
            onPressed: () => _showOptionsMenu(context),
          ),
        ],
      ),
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
            secondChild: Text(
              content,
              style: TextStyle(
                fontSize: 15,
                height: 1.5,
                color: isDark
                    ? Colors.white.withOpacity(0.9)
                    : AppColors.textPrimary,
              ),
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

  Widget _buildMediaSection() {
    final files = widget.post.files;

    if (files.length == 1) {
      return InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ImagePreview(imageUrls: [files[0].url]),
            ),
          );
        },
        child: _buildSingleMedia(files[0].url, files[0].fileType),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: 300,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentImageIndex = index);
            },
            itemCount: files.length,
            itemBuilder: (context, index) {
              return _buildSingleMedia(files[index].url, files[index].fileType);
            },
          ),
        ),
        if (files.length > 1) ...[
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              files.length,
              (index) =>
                  Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentImageIndex == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: _currentImageIndex == index
                              ? AppColors.primary
                              : AppColors.primary.withOpacity(0.3),
                        ),
                      )
                      .animate(target: _currentImageIndex == index ? 1 : 0)
                      .scaleX(duration: 300.ms, curve: Curves.easeInOut),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }

  Widget _buildSingleMedia(String url, String fileType) {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: fileType.startsWith('image')
            ? CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: AppColors.darkInput,
                  child: const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: AppColors.darkInput,
                  child: const Icon(
                    Icons.broken_image,
                    size: 50,
                    color: Colors.white54,
                  ),
                ),
              )
            : Container(
                color: AppColors.darkInput,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.play_circle_filled,
                      size: 64,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Video',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildTagsSection(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: widget.post.tags.map((tag) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withOpacity(0.15),
                  AppColors.primaryLight.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              '#$tag',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStatsSection(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _buildStatItem(
            Icons.favorite,
            widget.post.likesCount,
            AppColors.error,
            isDark,
          ),
          const SizedBox(width: 16),
          _buildStatItem(
            Icons.comment,
            widget.post.commentsCount,
            AppColors.info,
            isDark,
          ),
          const SizedBox(width: 16),
          _buildStatItem(
            Icons.share,
            widget.post.sharesCount,
            AppColors.success,
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, int count, Color color, bool isDark) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color.withOpacity(0.7)),
        const SizedBox(width: 4),
        Text(
          _formatCount(count),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white70 : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: _buildActionButton(
              icon: _isLiked ? Icons.favorite : Icons.favorite_border,
              label: 'like'.tr(),
              color: _isLiked ? AppColors.error : null,
              onTap: () {
                setState(() => _isLiked = !_isLiked);
                widget.onLike?.call();
              },
              isDark: isDark,
            ),
          ),
          Expanded(
            child: _buildActionButton(
              icon: Icons.comment_outlined,
              label: 'comment'.tr(),
              onTap: widget.onComment,
              isDark: isDark,
            ),
          ),
          Expanded(
            child: _buildActionButton(
              icon: Icons.share_outlined,
              label: 'share'.tr(),
              onTap: widget.onShare,
              isDark: isDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    Color? color,
    VoidCallback? onTap,
    required bool isDark,
  }) {
    final buttonColor =
        color ?? (isDark ? Colors.white70 : AppColors.textSecondary);

    return InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 22, color: buttonColor),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: buttonColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        )
        .animate(target: color != null ? 1 : 0)
        .scale(duration: 200.ms, curve: Curves.easeOut);
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : AppColors.lightSurface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                _buildMenuItem(Icons.bookmark_border, 'save_post'.tr(), isDark),
                _buildMenuItem(Icons.link, 'copy_link'.tr(), isDark),
                _buildMenuItem(
                  Icons.report_outlined,
                  'report'.tr(),
                  isDark,
                  isDestructive: true,
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ).animate().slideY(begin: 1, end: 0, duration: 300.ms);
      },
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String label,
    bool isDark, {
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive
            ? AppColors.error
            : (isDark ? Colors.white70 : AppColors.textPrimary),
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isDestructive
              ? AppColors.error
              : (isDark ? Colors.white : AppColors.textPrimary),
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        // Handle action
      },
    );
  }
}
