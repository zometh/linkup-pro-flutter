import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linkup_pro/core/entities/company.dart';
import 'package:linkup_pro/core/entities/member.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/core/widgets/custom_text.dart';
import 'package:linkup_pro/features/profile/presentation/widgets/expansion_text.dart';

import 'package:linkup_pro/features/profile/presentation/widgets/profile_header.dart';
import 'package:linkup_pro/features/profile/presentation/widgets/profile_meta_widget.dart';

import 'package:linkup_pro/features/profile/presentation/widgets/profile_stats.dart';

class ProfileTop extends ConsumerStatefulWidget {
  final BoxConstraints cx;
  final bool isOwnProfile;
  final bool isMember;
  final VoidCallback? onProfileUpdated;
  Member? memberInfos;
  Company? companyInfos;
  ProfileTop({
    super.key,
    required this.isMember,
    this.isOwnProfile = false,
    required this.cx,
    this.companyInfos,
    this.memberInfos,
    this.onProfileUpdated,
  });

  @override
  ConsumerState<ProfileTop> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends ConsumerState<ProfileTop> {
  bool get isOwnProfile => widget.isOwnProfile;
  Member? get memberInfos => widget.memberInfos;
  Company? get companyInfos => widget.companyInfos;
  bool get isMember => widget.isMember;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final screenHeight = MediaQuery.of(context).size.height;
    final headerHeight = screenHeight * 0.2;

    return Column(
      children: [
        SizedBox(
          height: headerHeight,
          child: ProfileHeader(
            isOwnProfile: isOwnProfile,
            cx: widget.cx,
            isMember: isMember,
            companyInfos: companyInfos,
            memberInfos: memberInfos,
            onProfileUpdated: widget.onProfileUpdated,
          ),
        ),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(12, 50, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: CustomText(
                      text: isMember
                          ? '${memberInfos!.user.firstName} ${memberInfos!.user.lastName}'
                          : companyInfos!.name,
                      fontSize: 18,
                      fontWeight: .w800,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  if (!isMember && companyInfos!.isValidated)
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Icon(
                        Icons.verified,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 2),

              CustomText(
                text:
                    '@${memberInfos?.user.username ?? companyInfos!.user.username}',

                fontSize: 15,
                color: isDarkMode ? Colors.grey[500] : Colors.grey[600],
              ),

              const SizedBox(height: 6),

              if (memberInfos?.biography != null ||
                  companyInfos?.description != null)
                ExpansionText(
                  isProfileBio: true,
                  text: memberInfos?.biography ?? companyInfos!.description,
                ),

              const SizedBox(height: 12),

              ProfileMetaWidget(
                isMember: isMember,
                company: companyInfos,
                member: memberInfos,
              ),

              GlobalProfileStats(
                followers: isMember
                    ? memberInfos!.user.followers!
                    : companyInfos!.user.followers!,

                following: isMember
                    ? memberInfos!.user.following!
                    : companyInfos!.user.following!,
              ),

              const SizedBox(height: 5),

              Divider(
                height: 1,
                thickness: 0.5,
                color: isDarkMode
                    ? Colors.white.withAlpha((0.1 * 255).round())
                    : Colors.black.withAlpha((0.1 * 255).round()),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
