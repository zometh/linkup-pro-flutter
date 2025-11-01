import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linkup_pro/core/widgets/my_animated_flipcounter.dart';
import 'package:linkup_pro/features/posts/domain/entities/user_preview_adds.dart';

import '../../../../core/enums/user_role.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_text.dart';
import '../../domain/entities/company_post.dart';
import '../../domain/entities/member_post.dart';
import '../../domain/entities/post.dart';

class AccountPreview extends StatefulWidget {
  final UserPreviewAdds userPreview;
  final Post post;

  /// Optional callback when follow state changes. Useful to update remote state.
  final ValueChanged<bool>? onFollowChanged;

  const AccountPreview({
    super.key,
    required this.post,
    this.onFollowChanged,
    required this.userPreview,
  });

  @override
  State<AccountPreview> createState() => _AccountPreviewState();
}

class _AccountPreviewState extends State<AccountPreview> {
  late bool _isFollowed;

  @override
  void initState() {
    super.initState();
    _isFollowed = widget.post.isFollowed;
  }

  void _toggleFollow() {
    setState(() {
      _isFollowed = !_isFollowed;
    });
    if (widget.onFollowChanged != null) widget.onFollowChanged!(_isFollowed);
  }

  @override
  Widget build(BuildContext context) {
    final owner = widget.post.owner;
    final isCompany = owner.role == UserRole.entreprise;
    final String content = widget.userPreview.companyDescription ?? widget.userPreview.biography ?? '';

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

    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, cx) {
        final width = cx.maxWidth;
        final height = cx.maxHeight;

        return SafeArea(
          child: Container(
            width: double.infinity,
            height: height * (content.length > 150 ? 0.35 : 0.28),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.lightSurface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(128, 128, 128, 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Avatar
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: avatarUrl == null
                            ? AppGradients.primaryGradient
                            : null,
                      ),
                      child: CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.transparent,
                        backgroundImage: avatarUrl != null
                            ? CachedNetworkImageProvider(avatarUrl)
                            : null,
                        child: avatarUrl == null
                            ? Text(
                                displayName.isNotEmpty
                                    ? displayName[0].toUpperCase()
                                    : '',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Flexible(
                      fit: FlexFit.loose,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 2,
                            children: [
                              CustomText(
                                text: displayName,

                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: isDark
                                    ? Colors.white
                                    : AppColors.textPrimary,
                              ),
                              CustomText(
                                text: '@${widget.userPreview.username}',
                                fontSize: 12,
                                color: isDark
                                    ? Colors.white70
                                    : AppColors.textSecondary,
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          if (owner.sector != null)
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
                                text: owner.sector!.tr(),
                                fontSize: 8,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Poppins",
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // keep button intrinsic size; don't force layout with flex
                    ElevatedButton(
                      onPressed: _toggleFollow,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isFollowed
                            ? Colors.transparent
                            : AppColors.primary,
                        elevation: 0,
                        side: BorderSide(
                          color: _isFollowed
                              ? Color.fromRGBO(71, 85, 105, .2)
                              : Colors.transparent,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        _isFollowed ? 'Following' : 'Follow',
                        style: TextStyle(
                          color: _isFollowed
                              ? (isDark ? Colors.white : AppColors.textPrimary)
                              : Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                //  const Divider(thickness: 0.3,),
                Align(
                  alignment: AlignmentDirectional.topStart,
                  child: CustomText(
                    text:
                        formatContent(widget.userPreview.companyDescription) ??
                        formatContent(widget.userPreview.biography) ??
                        '',
                    fontSize: 12,
                    color: isDark ? Colors.white70 : AppColors.textSecondary,
                    textAlign: TextAlign.start,
                  ),
                ),
                const Divider(thickness: 0.3),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              MyAnimatedFlipcounter(
                                value: widget.userPreview.followersCount,
                                fontSize: 12,
                              ),
                              const SizedBox(width: 4),
                              CustomText(text: "followers".tr(), fontSize: 12),
                            ],
                          ),
                          const SizedBox(width: 12),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              MyAnimatedFlipcounter(
                                value: widget.userPreview.followingCount,
                                fontSize: 12,
                              ),
                              const SizedBox(width: 4),
                              CustomText(text: "following".tr(), fontSize: 12),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  String? formatContent(String? content){
    final int max = 200;
    if(content==null) return null;
    if(content.length>max){
      return '${content.substring(0,max)}...';
    }else {
      return content;
    }
  }
}
