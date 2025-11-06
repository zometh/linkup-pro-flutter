import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:linkup_pro/core/routes/app_routes.dart';
import 'package:linkup_pro/features/posts/domain/entities/user_preview_adds.dart';
import 'package:linkup_pro/features/posts/domain/repos%20and%20implements/implementations/post_repository_implementaion.dart';
import 'package:linkup_pro/features/posts_actions/domain/repos_implementation/post_action_repository_implementation.dart';
import 'package:linkup_pro/features/report/domain/enums/report_content_type.dart';
import 'package:linkup_pro/features/report/presentation/pages/report_page.dart';
import 'package:linkup_pro/features/users/domain/user_repos_implement.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:toastification/toastification.dart';
import '../../../../core/enums/user_role.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_text.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../../../posts_actions/presentation/pages/post_action_page.dart';
import '../../domain/entities/company_post.dart';
import '../../domain/entities/member_post.dart';
import '../../domain/entities/post.dart';
import 'account_preview.dart';

class PostHeader extends StatefulWidget {
  final String userId;
  final Post post;
  const PostHeader({super.key, required this.post, required this.userId});

  @override
  State<PostHeader> createState() => _PostHeaderState();
}

class _PostHeaderState extends State<PostHeader> {
  UserPreviewAdds? userPreviewAdds;
  String get userId => widget.userId;
  bool isUserPostOwner = false;

  @override
  initState() {
    super.initState();
  }

  String displayName = '';

  @override
  Widget build(BuildContext context) {
    final owner = widget.post.owner;
    final isCompany = owner.role == UserRole.entreprise;

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
    isUserPostOwner = widget.post.userId == userId;

    return LayoutBuilder(
      builder: (_, cx) {
        return Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            spacing: 8,
            //crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Avatar
              GestureDetector(
                onTap: previewUser,
                child: Hero(
                  tag: 'avatar_${widget.post.id}',
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: avatarUrl == null
                          ? AppGradients.primaryGradient
                          : null,
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

              // User Info
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
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
                            color: isDark
                                ? Colors.white
                                : AppColors.textPrimary,
                            fontFamily: "Manrope",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        /* if (isCompany) ...[
                      const SizedBox(width: 4),
                      Icon(Icons.verified, size: 18, color: AppColors.primary),
                    ],*/
                      ],
                    ),
                    // >>> Changed: avoid spaceBetween overflow by letting right text use remaining space
                    Row(
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
                            text: owner.sector!.tr(),
                            fontSize: 8,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Poppins",
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Allow time text to shrink and ellipsize instead of forcing spaceBetween
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: CustomText(
                              text: timeago.format(
                                widget.post.publicationDate,
                                locale: context.locale.languageCode,
                                allowFromNow: false,
                              ),
                              fontSize: 11,
                              color: isDark
                                  ? Colors.white60
                                  : AppColors.textSecondary,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              PopupMenuButton<int>(
                popUpAnimationStyle: AnimationStyle(
                  reverseCurve: Curves.easeInOut,
                  curve: Curves.easeInOut,
                  duration: 300.ms,
                ),
                style: ButtonStyle(),
                onSelected: action,
                itemBuilder: (context) => [
                  // PopupMenuItem 1
                  if(isUserPostOwner)PopupMenuItem(
                    value: 1,
                    // row with 2 children
                    child: Row(
                      spacing: 10,
                      children: [
                        const Icon(Icons.delete),

                        CustomText(

                              text: "delete".tr()
                           
                        ),
                      ],
                    ),
                  ),

                  if(isUserPostOwner) PopupMenuItem(
                    value: 2,
                    // row with two children
                    child: Row(
                      spacing: 10,
                      children: [
                        const Icon(Icons.edit),
                        CustomText(text:"edit".tr()),
                      ],
                    ),
                  ),
                  if(!isUserPostOwner) PopupMenuItem(
                    value: 3,
                      child: Row(
                        spacing: 10,
                        children: [
                          const Icon(FontAwesomeIcons.triangleExclamation),
                          CustomText(text: "report".tr()),
                        ],
                      )
                  )
                  
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  previewUser() async {

    final postImplement = GetIt.I<PostRepositoryImpl>();
    final response = await postImplement.getUserPreview(widget.post.userId);
    userPreviewAdds = response.fold(
      (failure) {
        // Handle failure
        return null;
      },
      (data) {
        return data;
      },
    );
    if (mounted) {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (ctx) => AccountPreview(
          userPreview: userPreviewAdds!,
          post: widget.post,
          onFollowChanged: () async => await action(0),
        ).animate().slideY(begin: 1, end: 0, duration: 300.ms),
      );
    }
  }

  deletePost() async {
    final postActionImplements = GetIt.I<PostActionRepositoryImplementation>();
    final response = await postActionImplements.deletePost(widget.post.id);
    response.fold((failure) {}, (isDeleted) {
      if (mounted) {
        showToast(
          description: 'post_deleted_successfully'.tr(),
          type: ToastificationType.success,

        );
      }
    });
  }

  action(int value) async {
    if(value == 3){
      MyNavigator(context).navigateTo(ReportPage(reportType: ReportContentType.publication));
      return;
    }
    if (isUserPostOwner && value == 1) {
      await deletePost();
      return;
    }
    if(isUserPostOwner && value == 2){
      MyNavigator(context).navigateTo( PostActionPage(isEdit: true, postId: widget.post.id,));
      return ;
    }
    
    final usersImplements = GetIt.I<UsersRepositoryImpl>();
    final response = await usersImplements.followOrUnfollow(widget.post.userId);
    response.fold((failure) {}, (isFollowed) {
      setState(() {
        widget.post.isFollowed = isFollowed;
        userPreviewAdds!.followersCount += isFollowed ? 1 : -1;
      });

      showToast(
        description: (isFollowed ? "followed_successfully" : "unfollowed_successfully")
            .tr(namedArgs: {"name": displayName}),
        type: ToastificationType.info,

      );

    });
  }
}
