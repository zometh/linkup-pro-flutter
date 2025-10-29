import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:go_router/go_router.dart';
import '../../../../core/enums/user_role.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_text.dart';
import '../../domain/entities/company_post.dart';
import '../../domain/entities/member_post.dart';
import '../../domain/entities/post.dart';
 class PostHeader extends StatelessWidget {
   final Post post;
   const PostHeader({super.key, required this.post});
 
   @override
   Widget build(BuildContext context) {
     final owner = post.owner;
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
     return Padding(
       padding: const EdgeInsets.all(14),
       child: Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: [
           // Avatar
           GestureDetector(
             onTap: null,
             child: Hero(
               tag: 'avatar_${post.id}',
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

           const SizedBox(width: 12),

           // User Info
           Expanded(
             child: Column(
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
                         text: owner.sector.tr(),
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
                               post.publicationDate,
                               locale: context.locale.languageCode,
                               allowFromNow: false
                           ),
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
                 _buildMenuItem(Icons.bookmark_border,context, 'save_post'.tr(), isDark),
                 _buildMenuItem(Icons.link,context, 'copy_link'.tr(), isDark),
                 _buildMenuItem(
                   Icons.report_outlined,
                   context,
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
 


