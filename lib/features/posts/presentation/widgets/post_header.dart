import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get_it/get_it.dart';
import 'package:linkup_pro/features/posts/domain/repos%20and%20implements/implementations/post_repository_implementaion.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../../core/enums/user_role.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_text.dart';
import '../../domain/entities/company_post.dart';
import '../../domain/entities/member_post.dart';
import '../../domain/entities/post.dart';
import 'account_preview.dart';

class PostHeader extends StatefulWidget {
  final Post post;
  const PostHeader({super.key, required this.post});

  @override
  State<PostHeader> createState() => _PostHeaderState();
}

class _PostHeaderState extends State<PostHeader> {
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
    // TODO: dispatch provider or API call to persist follow change
  }

  @override
  Widget build(BuildContext context) {
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
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return LayoutBuilder(
        builder: (_, cx){
          final width = cx.maxWidth;
          final height = cx.maxHeight;
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
                              text: displayName[0].toUpperCase() + displayName.substring(1),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: isDark ? Colors.white : AppColors.textPrimary,
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
                                    allowFromNow: false),
                                fontSize: 11,
                                color: isDark ? Colors.white60 : AppColors.textSecondary,
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
  curve: Curves.easeInOut,
  duration: 300.ms,
),
              style: ButtonStyle(

              ),
              itemBuilder: (context) => [
                // PopupMenuItem 1
                PopupMenuItem(
                  value: 1,
                  // row with 2 children
                  child: Row(
                    children: [
                      const Icon(Icons.star),
                      SizedBox(width: 10,),
                      const Text("Get The App")
                    ],
                  ),
                ),
                // PopupMenuItem 2
                PopupMenuItem(
                  value: 2,
                  // row with two children
                  child: Row(
                    children: [
                      const Icon(Icons.chrome_reader_mode),
                      SizedBox(
                        width: 10,
                      ),
                      const Text("About")
                    ],
                  ),
                ),


              ]
            )
            ],
            ),

          );
        }
    );
  }
  previewUser()async{
    final postImplement = GetIt.I<PostRepositoryImpl>();
    final response = await postImplement.getUserPreview( widget.post.userId);
    final result = response.fold(
          (failure) {
        // Handle failure
        return null;
      },
          (data) {
        return data;
      },
    );
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => AccountPreview(userPreview: result!,post: widget.post, onFollowChanged: (val) {
        setState(() => _isFollowed = val);
      }).animate( )
      .slideY(begin: 1, end: 0, duration: 300.ms)
    );
  }
  void _showOptionsMenu() {
    
  }

  Widget _buildMenuItem(
      IconData icon,
      BuildContext context,
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
