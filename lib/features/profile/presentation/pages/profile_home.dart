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
import 'package:linkup_pro/features/posts/presentation/pages/posts_view.dart';
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

class _ProfileHomeState extends ConsumerState<ProfileHome>
    with TickerProviderStateMixin {
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
        return DefaultTabController(
          length: 3,
          child: Scaffold(
            backgroundColor: isDarkMode
                ? AppColors.darkBackground
                : AppColors.lightBackground,
            body: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverToBoxAdapter(
                    child: ProfileTop(
                      isMember: isMember,
                      cx: cx,
                      isOwnProfile: widget.isOwnProfile,
                      memberInfos: memberInfos,
                      companyInfos: companyInfos,
                    ),
                  ),
                  SliverPersistentHeader(
                    delegate: _SliverTabBarDelegate(
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? const Color(0xFF2D2D2D)
                              : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: TabBar(
                          dividerColor: Colors.transparent,
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicator: BoxDecoration(
                            color: isDarkMode
                                ? AppColors.primary
                                : Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              if (!isDarkMode)
                                BoxShadow(
                                  color: Colors.black.withAlpha(10),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                            ],
                          ),
                          labelColor: isDarkMode
                              ? Colors.white
                              : AppColors.primary,
                          unselectedLabelColor: isDarkMode
                              ? Colors.white54
                              : Colors.grey,
                          labelStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                          tabs: const [
                            Tab(text: "Posts", height: 40),
                            Tab(text: "Compétences", height: 40),
                            Tab(text: "Expériences", height: 40),
                          ],
                        ),
                      ),
                      isDarkMode: isDarkMode,
                      height:
                          60, // 40 (tab height) + 16 (vertical margin) + 4 (padding/safety)
                    ),
                    pinned: true,
                  ),
                ];
              },
              body: TabBarView(
                children: [
                  // Posts Tab
                  PostsView(isMyPosts: isOwnProfile),
                  // Skills Tab
                  Center(child: CustomText(text: "Compétences")),
                  // Experiences Tab
                  Center(child: CustomText(text: "Expériences")),
                ],
              ),
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
      if (mounted) {
        Future.microtask(
          () => setState(() {
            isMember = true;
            memberInfos = localData as Member;
            isLoading = false;
          }),
        );
      }
    } else {
      Future.microtask(
        () => setState(() {
          isMember = false;
          companyInfos = localData as Company;
          isLoading = false;
        }),
      );
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

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget _tabBar;
  final bool isDarkMode;
  final double height;

  _SliverTabBarDelegate(
    this._tabBar, {
    required this.isDarkMode,
    this.height = 65,
  });

  @override
  double get minExtent => height;
  @override
  double get maxExtent => height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      height: height,
      color: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return oldDelegate.height != height || oldDelegate.isDarkMode != isDarkMode;
  }
}
