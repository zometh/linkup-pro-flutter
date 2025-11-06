import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linkup_pro/core/entities/company.dart';
import 'package:linkup_pro/core/entities/member.dart';
import 'package:linkup_pro/core/entities/user.dart';
import 'package:linkup_pro/core/enums/user_role.dart';
import 'package:linkup_pro/core/enums/user_visibility.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';

class ProfileHeader extends StatelessWidget {
  final String? userId;
  final BoxConstraints cx;
  final bool isOwnProfile;

  const ProfileHeader({
    super.key,

    this.isOwnProfile = false,
    required this.cx,
    this.userId,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final mockMember =  Member(
      id: '1',
      biography: 'Passionate software developer | Flutter enthusiast 🚀 | Building the future one app at a time',
      birthDate: DateTime(1995, 3, 15),
      phone: '+221 77 123 45 67',
      portfolio: 'https://portfolio.example.com',
      photoUrl: null,
      sector: 'Tech & Digital',
      profileVisibility: UserVisibility.public,
      user: User(
        id: '1',
        email: 'john.doe@example.com',
        username: 'johndoe',
        firstName: 'John',
        lastName: 'Doe',
        address: 'Dakar, Senegal',
        role: UserRole.member,
        password: '',
      ),
    );

    final mockCompany =  Company(
      id: '1',
      name: 'TechCorp Solutions',
      creationDate: DateTime(2018, 6, 1),
      website: 'https://techcorp.example.com',
      logo: '',
      profileFileId: '123',
      phone: '+221 33 123 45 67',
      isValidated: true,
      description: 'Leading technology company 💼 | Digital transformation experts | Building innovative solutions for tomorrow',
      size: 'medium_business',
      sector: 'Tech & Digital',
      user: User(
        id: '2',
        email: 'contact@techcorp.com',
        username: 'techcorp',
        firstName: 'Tech',
        lastName: 'Corp',
        address: 'Plateau, Dakar',
        role: UserRole.entreprise,
        password: '',
      ),
    );

    final isMember = member != null || company == null;
    final displayMember = isMember ? mockMember : null;
    final displayCompany = !isMember ? mockCompany : null;
    final width = cx.maxWidth;
    final height = cx.maxHeight;
    return Column(
      children: [
        // Cover Banner - Twitter style
        Stack(
          clipBehavior: Clip.none,
          children: [
            // Cover Image
            Container(
              height: height * 0.2,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  stops: [
                    0.0,
                    1.0,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary,
                    AppColors.primaryDark,
                  ],
                ),
              ),
            ),

            // Back button (if not own profile)
            if (!isOwnProfile)
              Positioned(
                top: MediaQuery.of(context).padding.top + 8,
                left: 8,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),

            // Profile Avatar - positioned at bottom overlapping
            Positioned(
              bottom: -40,
              left: 16,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDarkMode ? AppColors.darkBackground : Colors.white,
                    width: 4,
                  ),
                ),
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundColor: isDarkMode ? AppColors.darkCard : Colors.grey[200],
                      child: displayMember != null && displayMember.photoUrl != null
                          ? ClipOval(
                              child: Image.network(
                                displayMember.photoUrl!,
                                fit: BoxFit.cover,
                                width: 136,
                                height: 136,
                              ),
                            )
                          : displayCompany != null && displayCompany.logo.isNotEmpty
                              ? ClipOval(
                                  child: Image.network(
                                    displayCompany.logo,
                                    fit: BoxFit.cover,
                                    width: 136,
                                    height: 136,
                                  ),
                                )
                              : Icon(
                                  isMember ? Icons.person : Icons.business,
                                  size: 60,
                                  color: AppColors.primary,
                                ),
                    ),
                    // Verified badge for companies
                    if (displayCompany != null && displayCompany.isValidated)
                      Positioned(
                        bottom: 4,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDarkMode ? AppColors.darkBackground : Colors.white,
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.verified,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            Positioned(
              bottom: 16,
              right: 16,
              child: isOwnProfile
                  ? ActionButton(
                      label: 'edit'.tr(),
                      onPressed: () {},
                      isDarkMode: isDarkMode,
                      isOutlined: true,
                    )
                  : Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: isDarkMode ? AppColors.darkCard : Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDarkMode
                                  ? Colors.white.withValues(alpha: 0.2)
                                  : Colors.black.withValues(alpha: 0.1),
                            ),
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.more_horiz,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                            onPressed: () => _showMoreOptions(context),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: isDarkMode ? AppColors.darkCard : Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDarkMode
                                  ? Colors.white.withValues(alpha: 0.2)
                                  : Colors.black.withValues(alpha: 0.1),
                            ),
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.mail_outline,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                            onPressed: () {},
                          ),
                        ),
                        const SizedBox(width: 8),
                        ActionButton(
                          label: 'follow'.tr(),
                          onPressed: () {},
                          isDarkMode: isDarkMode,
                          isPrimary: true,
                        ),
                      ],
                    ),
            ),
          ],
        ),

        Container(
          width: double.infinity,
          color: isDarkMode ? AppColors.darkBackground : Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 56, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name and verified badge
              Row(
                children: [
                  Flexible(
                    child: Text(
                      displayMember != null
                          ? '${displayMember.user.firstName} ${displayMember.user.lastName}'
                          : displayCompany!.name,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: isDarkMode ? Colors.white : Colors.black,
                        height: 1.2,
                      ),
                    ),
                  ),
                  if (displayCompany != null && displayCompany.isValidated)
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

              // Username
              Text(
                '@${displayMember?.user.username ?? displayCompany!.user.username}',
                style: TextStyle(
                  fontSize: 15,
                  color: isDarkMode ? Colors.grey[500] : Colors.grey[600],
                ),
              ),

              const SizedBox(height: 12),

              // Bio/Description
              if (displayMember?.biography != null || displayCompany?.description != null)
                Text(
                  displayMember?.biography ?? displayCompany!.description,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.4,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),

              const SizedBox(height: 12),

              // Meta info (location, link, joined date) - Twitter style
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  if (displayMember?.user.address != null || displayCompany?.user.address != null)
                    ProfileMetaInfo(
                      icon: Icons.location_on_outlined,
                      text: displayMember?.user.address ?? displayCompany!.user.address!,
                      isDarkMode: isDarkMode,
                    ),
                  if (displayMember?.portfolio != null)
                    ProfileMetaInfo(
                      icon: Icons.link,
                      text: 'portfolio.example.com',
                      isDarkMode: isDarkMode,
                      isLink: true,
                    ),
                  if (displayCompany?.website != null)
                    ProfileMetaInfo(
                      icon: Icons.link,
                      text: 'techcorp.example.com',
                      isDarkMode: isDarkMode,
                      isLink: true,
                    ),
                  ProfileMetaInfo(
                    icon: Icons.calendar_today_outlined,
                    text: displayCompany != null
                        ? 'Joined ${DateFormat('MMMM yyyy').format(displayCompany.creationDate)}'
                        : 'Joined March 2020',
                    isDarkMode: isDarkMode,
                  ),
                  ProfileMetaInfo(
                    icon: Icons.work_outline,
                    text: (displayMember?.sector ?? displayCompany!.sector).tr(),
                    isDarkMode: isDarkMode,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Following/Followers count - Twitter style
              Row(
                children: [
                  ProfileStats(
                    count: '567',
                    label: 'following'.tr(),
                    isDarkMode: isDarkMode,
                    onTap: () {},
                  ),
                  const SizedBox(width: 20),
                  ProfileStats(
                    count: '1.2K',
                    label: 'followers'.tr(),
                    isDarkMode: isDarkMode,
                    onTap: () {},
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Divider
              Divider(
                height: 1,
                thickness: 0.5,
                color: isDarkMode
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.1),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showMoreOptions(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.darkSurface : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? Colors.white.withValues(alpha: 0.3)
                      : Colors.black.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ProfileMoreOption(
                icon: Icons.block_outlined,
                label: 'Block',
                isDarkMode: isDarkMode,
                onTap: () => Navigator.pop(context),
              ),
              ProfileMoreOption(
                icon: Icons.flag_outlined,
                label: 'report'.tr(),
                isDarkMode: isDarkMode,
                isDestructive: true,
                onTap: () => Navigator.pop(context),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

// Twitter-style button
class ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isDarkMode;
  final bool isPrimary;
  final bool isOutlined;

  const ActionButton({super.key,
    required this.label,
    required this.onPressed,
    required this.isDarkMode,
    this.isPrimary = false,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isPrimary
                ? (isDarkMode ? Colors.white : Colors.black)
                : isOutlined
                    ? Colors.transparent
                    : (isDarkMode ? AppColors.darkCard : Colors.white),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isOutlined || !isPrimary
                  ? (isDarkMode
                      ? Colors.white.withValues(alpha: 0.3)
                      : Colors.black.withValues(alpha: 0.2))
                  : Colors.transparent,
              width: 1,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isPrimary
                  ? (isDarkMode ? Colors.black : Colors.white)
                  : (isDarkMode ? Colors.white : Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}

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

// Twitter-style follow count
class ProfileStats extends StatelessWidget {
  final String count;
  final String label;
  final bool isDarkMode;
  final VoidCallback onTap;

  const ProfileStats({super.key,
    required this.count,
    required this.label,
    required this.isDarkMode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: count,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              TextSpan(
                text: ' $label',
                style: TextStyle(
                  fontSize: 14,
                  color: isDarkMode ? Colors.grey[500] : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Twitter-style more option item
class ProfileMoreOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDarkMode;
  final bool isDestructive;
  final VoidCallback onTap;

  const ProfileMoreOption({super.key,
    required this.icon,
    required this.label,
    required this.isDarkMode,
    this.isDestructive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive
            ? AppColors.error
            : (isDarkMode ? Colors.white : Colors.black),
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isDestructive
              ? AppColors.error
              : (isDarkMode ? Colors.white : Colors.black),
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}



