import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linkup_pro/core/entities/member.dart';
import 'package:linkup_pro/core/entities/company.dart';
import 'package:linkup_pro/features/profile/domain/mapping/get_icon_by_sector.dart';

import '../../../../core/theme/app_colors.dart';

class ProfileMetaInfo extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isDarkMode;
  final bool isLink;

  const ProfileMetaInfo({super.key,
    required this.icon,
    required this.text,
    required this.isDarkMode,
    this.isLink = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: isDarkMode ? Colors.grey[500] : Colors.grey[600],
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: isLink
                ? AppColors.primary
                : (isDarkMode ? Colors.grey[500] : Colors.grey[600]),
          ),
        ),
      ],
    );
  }
}

class ProfileMetaWidget extends StatelessWidget {
  final Member? member;
  final bool isMember;
  final Company? company;
  const ProfileMetaWidget({super.key, this.member, this.company, required this.isMember});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: [
        if (member?.user.address != null || company?.user.address != null)
          ProfileMetaInfo(
            icon: Icons.location_on_outlined,
            text: member?.user.address ?? company!.user.address!,
            isDarkMode: isDarkMode,
          ),
        if (member?.portfolio != null)
          ProfileMetaInfo(
            icon: Icons.link,
            text: member!.portfolio!,
            isDarkMode: isDarkMode,
            isLink: true,
          ),
        if (company?.website != null)
          ProfileMetaInfo(
            icon: Icons.link,
            text: company!.website,
            isDarkMode: isDarkMode,
            isLink: true,
          ),
        ProfileMetaInfo(
          icon: Icons.calendar_today_outlined,
          text: isMember
              ? "${"joined".tr()}${DateFormat('MMMM yyyy').format(member!.user.registrationDate!)}"
              : "${"joined".tr()}${DateFormat('MMMM yyyy').format(company!.creationDate)}",
          isDarkMode: isDarkMode,
        ),
        ProfileMetaInfo(
          icon: getIconBySector(isMember ? member!.sector : company!.sector)/*Icons.work_outline*/,
          text: (member?.sector ?? company!.sector).tr(),
          isDarkMode: isDarkMode,
        ),
      ],
    );
  }
}
