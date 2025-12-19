import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkup_pro/core/entities/company.dart';
import 'package:linkup_pro/core/entities/member.dart';
import 'package:linkup_pro/core/enums/user_role.dart';
import 'package:linkup_pro/core/network/websocket/config.dart';
import 'package:linkup_pro/core/services/localdb/localdb.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/core/widgets/custom_progress.dart';
import 'package:linkup_pro/core/widgets/custom_text.dart';
import 'package:linkup_pro/core/widgets/custom_toast.dart';
import 'package:linkup_pro/features/posts/presentation/pages/posts_view.dart';
import 'package:linkup_pro/features/profile/presentation/widgets/profile_top.dart';
import 'package:linkup_pro/features/profile_jobs/presentation/pages/profile_jobs_page.dart';
import 'package:linkup_pro/features/profile_skills/presentation/pages/profile_skills_page.dart';
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
  final _socketService = GetIt.I<SocketService>();

  bool isMember = false;
  bool hasError = false;
  bool isLoading = false;
  String? currentUserId;

  Member? memberInfos;
  Company? companyInfos;

  @override
  void initState() {
    super.initState();
    fetchCurrentUserInfos();
    fetchCurrentUserId();
    _listenToFollowUpdates();
  }

  @override
  void dispose() {
    _socketService.off('followUpdate');
    super.dispose();
  }

  /// Écouter les mises à jour de follow en temps réel
  void _listenToFollowUpdates() {
    _socketService.on('followUpdate', (data) {
      if (!mounted) return;

      final type = data['type'] as String?;
      final followersCount = data['followersCount'] as int?;
      final followingCount = data['followingCount'] as int?;

      if (followersCount != null && followingCount != null) {
        setState(() {
          if (isMember && memberInfos != null) {
            memberInfos!.user.followers = followersCount;
            memberInfos!.user.following = followingCount;
          } else if (!isMember && companyInfos != null) {
            companyInfos!.user.followers = followersCount;
            companyInfos!.user.following = followingCount;
          }
        });
      }
    });
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
                      onProfileUpdated: () {
                        // Recharger les données du profil après modification
                        setState(() {
                          isLoading = true;
                        });
                        fetchCurrentUserInfos();
                      },
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
                          labelStyle: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                          tabs:  [
                            Tab(text: "Posts", height: 40),
                            if(isOwnProfile)Tab(text: "skills".tr(), height: 40),
                            if(isOwnProfile)Tab(text: "experiences".tr(), height: 40),
                          ],
                        ),
                      ),
                      isDarkMode: isDarkMode,
                      height: 60,
                    ),
                    pinned: true,
                  ),
                ];
              },
              body: TabBarView(
                children: [
                  PostsView(userId: isOwnProfile ? currentUserId : userId,),
                  if(isOwnProfile)ProfileSkillsPage(userId:  isOwnProfile ? currentUserId! : userId!,isOwnProfile: isOwnProfile,),
                   if(isOwnProfile)ProfileJobsPage(userId:  isOwnProfile ? currentUserId! : userId!,isOwnProfile: isOwnProfile),
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
      // Charger aussi depuis l'API pour avoir les compteurs à jour
      await initOwnProfileData();
    }
  }

  initOwnProfileData() async {
    setState(() {
      isLoading = true;
    });

    try {
      // D'abord récupérer l'ID de l'utilisateur connecté
      final ownUserId = await localDb.getUserId();
      if (ownUserId == null) {
        await initLocalData();
        return;
      }

      // Charger les données depuis l'API pour avoir les compteurs à jour
      final response = await ref
          .read(usersProvider.notifier)
          .getUserById(ownUserId);

      if (response == null) {
        await initLocalData();
        return;
      }

      final role = userRoleFromString(response["user"]['role']);
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
      // En cas d'erreur, utiliser les données locales
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
  fetchCurrentUserId() async {
    if(isOwnProfile){
      final userId = await localDb.getUserId();
      setState(() {
        currentUserId = userId;
      });
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
