import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:linkup_pro/core/entities/company.dart';
import 'package:linkup_pro/core/entities/member.dart';
import 'package:linkup_pro/core/enums/user_role.dart';
import 'package:linkup_pro/core/services/localdb/localdb.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/core/widgets/custom_progress.dart';
import 'package:linkup_pro/core/widgets/custom_text.dart';
import 'package:linkup_pro/core/widgets/custom_toast.dart';
import 'package:linkup_pro/features/profile/presentation/widgets/profile_top.dart';
import 'package:linkup_pro/features/users/presentation/providers/users.dart';
import 'package:toastification/toastification.dart';

class ProfileHome extends ConsumerStatefulWidget {
  final bool isOwnProfile;
  String? userId;
  ProfileHome({super.key, required this.isOwnProfile, this.userId});

  @override
  ConsumerState<ProfileHome> createState() => _ProfileHomeState();
}

class _ProfileHomeState extends ConsumerState<ProfileHome> {
  bool get isOwnProfile => widget.isOwnProfile;
  String? get userId => widget.userId;

  final localDb = GetIt.I<LocalDBService>();
  bool isMember = false;
  bool hasError = false;
  bool isLoading = false;

  Member? memberInfos;
  Company? companyInfos;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCurrentUserInfos();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final loadingWidget = const CustomProgress();
    if (hasError) {
      return Center(child: CustomText(text: "error_occured".tr()));
    }
    if (isOwnProfile) {
      if (ref.watch(usersProvider)) {
        return loadingWidget;
      }
    }
    if (isLoading) {
      return loadingWidget;
    }

    if (isMember && memberInfos == null) {
      return loadingWidget;
    }
    if (!isMember && companyInfos == null) {
      return loadingWidget;
    }

    return LayoutBuilder(
      builder: (_, cx) {
        return Scaffold(
          backgroundColor: isDarkMode
              ? AppColors.darkBackground
              : AppColors.lightBackground,
          body: SingleChildScrollView(
            child: Column(
              children: [
                ProfileTop(
                  isMember: isMember,
                  cx: cx,
                  isOwnProfile: widget.isOwnProfile,
                  memberInfos: memberInfos,
                  companyInfos: companyInfos,
                ),

                // Tabs ou contenu supplémentaire
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Tabs pour Posts, About, Media, etc.
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: isDarkMode ? AppColors.darkCard : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            _TabItem(
                              label: 'Posts',
                              isSelected: true,
                              isDarkMode: isDarkMode,
                            ),
                            _TabItem(
                              label: 'About',
                              isSelected: false,
                              isDarkMode: isDarkMode,
                            ),
                            _TabItem(
                              label: 'Media',
                              isSelected: false,
                              isDarkMode: isDarkMode,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Placeholder pour le contenu
                      Container(
                        padding: const EdgeInsets.all(40),
                        decoration: BoxDecoration(
                          color: isDarkMode ? AppColors.darkCard : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.article_outlined,
                                size: 60,
                                color: isDarkMode
                                    ? Colors.white.withValues(alpha: 0.3)
                                    : AppColors.textTertiary,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No posts yet',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: isDarkMode
                                      ? Colors.white60
                                      : AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Start sharing your thoughts',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isDarkMode
                                      ? Colors.white38
                                      : AppColors.textTertiary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  initLocalData() async {
    final localdb = GetIt.I<LocalDBService>();
    final localData = await localdb.getUserInfos();
    if (localData == null) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
      return;
    }
    final role = await localdb.getUserRole();
    if (role == UserRole.member) {
      setState(() {
        isMember = true;
        memberInfos = localData as Member;
        isLoading = false;
      });
    } else {
      setState(() {
        isMember = false;
        companyInfos = localData as Company;
        isLoading = false;
      });
    }
  }

  fetchCurrentUserInfos() async {
    if (!isOwnProfile) {
      await initRemoteData();
    } else {
      await initLocalData();
    }
  }

  initRemoteData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await ref
          .read(usersProvider.notifier)
          .getUserById(userId!);
      final role = userRoleFromString(response!["user"]['role']);
      if (role == UserRole.member) {
        setState(() {
          isMember = true;
          memberInfos = Member.fromJson(response);
          isLoading = false;
        });
      } else {
        setState(() {
          isMember = false;
          companyInfos = Company.fromJson(response);
          isLoading = false;
        });
      }
    } catch (e) {
      showToast(
        description: "error_occured".tr(),
        type: ToastificationType.error,
      );
      setState(() {
        hasError = true;
        isLoading = false;
      });
      rethrow;
    }
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool isDarkMode;

  const _TabItem({
    required this.label,
    required this.isSelected,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          gradient: isSelected ? AppGradients.primaryGradient : null,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected
                ? Colors.white
                : isDarkMode
                ? Colors.white60
                : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
