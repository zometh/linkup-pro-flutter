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
import 'package:linkup_pro/features/profile/presentation/widgets/profile_action_button.dart';
import 'package:linkup_pro/features/profile/presentation/widgets/profile_meta_info.dart';
import 'package:linkup_pro/features/profile/presentation/widgets/profile_more_option.dart';
import 'package:linkup_pro/features/profile/presentation/widgets/profile_stats.dart';
import 'package:linkup_pro/features/users/presentation/providers/users.dart';
import 'package:toastification/toastification.dart';

class ProfileHeader extends ConsumerStatefulWidget {
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
  ConsumerState<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends ConsumerState<ProfileHeader> {
  bool get isOwnProfile => widget.isOwnProfile;
  String?  get userId => widget.userId;
  bool isMember = false;
  bool hasError =  false;
  bool isLoading = false;
  Member? memberInfos;
  Company? companyInfos;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchCurrentUserInfos();
    });
  }
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;


    final loadingWidget = const CustomProgress();
    if(hasError){
      return Center(
        child: CustomText(text: "error_occured".tr()),
      );
    }
    if(isOwnProfile){
      if(ref.watch(usersProvider)){
        return loadingWidget;
      }
    }
    if(isLoading){
      return loadingWidget;
    }

    // Vérifier que les données sont chargées
    if (isMember && memberInfos == null) {
      return loadingWidget;
    }
    if (!isMember && companyInfos == null) {
      return loadingWidget;
    }
    final width = widget.cx.maxWidth;
    final height = widget.cx.maxHeight;
    return Column(
      children: [
        // Cover Banner - Twitter style
        Stack(
          clipBehavior: Clip.none,
          children: [
            // Cover Image
            Container(
              height: height * 0.18,
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
            if (!widget.isOwnProfile)
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
              bottom: -50,
              left: 5,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDarkMode ? AppColors.darkBackground : Colors.white,
                    width: 4,
                  ),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CircleAvatar(
                      radius: 37,
                      backgroundColor: isDarkMode ? AppColors.darkCard : Colors.grey[200],
                      backgroundImage: isMember && memberInfos!.photoUrl != null
                          ? NetworkImage(memberInfos!.photoUrl!)
                          : companyInfos != null && companyInfos!.logo.isNotEmpty
                              ? NetworkImage(companyInfos!.logo)
                              : null,
                      child: (isMember && memberInfos!.photoUrl == null) ||
                             (companyInfos != null && companyInfos!.logo.isEmpty)
                          ? Icon(
                              isMember ? Icons.person : Icons.business,
                              size: 50,
                              color: AppColors.primary,
                            )
                          : null,
                    ),
                    if (companyInfos != null && companyInfos!.isValidated)
                      Positioned(
                        bottom: 2,
                        right: 2,
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
              child: widget.isOwnProfile
                  ? ProfileActionButton(
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
                        ProfileActionButton(
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
          //color: Colors.transparent/*isDarkMode ? AppColors.darkBackground : Colors.white*/,
          padding: const EdgeInsets.fromLTRB(12, 50, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name and verified badge
              Row(
                children: [
                  Flexible(
                    child: CustomText(
                      text: isMember
                          ? '${memberInfos!.user.firstName} ${memberInfos!.user.lastName}'
                          : companyInfos!.name,

                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: isDarkMode ? Colors.white : Colors.black,
                        //height: 1.2,

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

              // Username
              CustomText(
                text:'@${memberInfos?.user.username ?? companyInfos!.user.username}',

                  fontSize: 15,
                  color: isDarkMode ? Colors.grey[500] : Colors.grey[600],

              ),

              const SizedBox(height: 6),

              // Bio/Description
              if (memberInfos?.biography != null || companyInfos?.description != null)
                CustomText(
                  text: memberInfos?.biography ?? companyInfos!.description,
                    fontSize: 14,
                   fontFamily: "Roboto",
                   fontWeight: FontWeight.w300,
                   // height: 1.4,
                    color: isDarkMode ? Colors.white : Colors.black,
                ),

              const SizedBox(height: 12),

              // Meta info (location, link, joined date) - Twitter style
              ProfileMetaWidget(isMember: isMember, company: companyInfos, member: memberInfos),

             // const SizedBox(height: 5),

             GlobalProfileStats(followers: isMember ? memberInfos!.user.followers! : companyInfos!.user.followers!,

             following: isMember ? memberInfos!.user.following! : companyInfos!.user.following!),

              const SizedBox(height: 5),

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
  initLocalData() async{
    final localdb = GetIt.I<LocalDBService>();
    final localData = await localdb.getUserInfos();
    if(localData == null){
      setState(() {
        hasError = true;
        isLoading = false;
      });
      return;
    }
    final role = await localdb.getUserRole();
    if(role == UserRole.member){
      setState(() {
        isMember = true;
        memberInfos = localData as Member;
        isLoading = false;
      });
    }else{
      setState(() {
        isMember = false;
        companyInfos = localData as Company;
        isLoading = false;
      });
    }

  }
  fetchCurrentUserInfos() async{

    if(!isOwnProfile){
      await initRemoteData();
    }
    else{
      await initLocalData();
    }
  }
  initRemoteData() async{
    setState(() {
      isLoading = true;
    });

    try{
      print("userId in profile header: $userId");
      final response = await ref.read(usersProvider.notifier).getUserById(userId!);
      final role = userRoleFromString(response!["user"]['role']);
      if(role == UserRole.member) {
        setState(() {
          isMember = true;
          memberInfos = Member.fromJson(response);
          isLoading = false;
        });
      }
      else{
        setState(() {
          isMember = false;
          companyInfos = Company.fromJson(response);
          isLoading = false;
        });
      }
    }catch(e){
      showToast(description: "error_occured".tr(),
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




