import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:linkup_pro/core/entities/company.dart';
import 'package:linkup_pro/core/entities/member.dart';
import 'package:linkup_pro/core/services/localdb/localdb.dart';
import 'package:linkup_pro/features/profile/presentation/pages/edit_member_profile_page.dart';
import 'package:linkup_pro/features/profile/presentation/pages/edit_company_profile_page.dart';

class EditProfileButton extends ConsumerWidget {
  final VoidCallback? onProfileUpdated;

  const EditProfileButton({super.key, this.onProfileUpdated});

  Future<void> _navigateToEditProfile(BuildContext context) async {
    final localdb = GetIt.I<LocalDBService>();
    final userInfos = await localdb.getUserInfos();

    if (userInfos == null || !context.mounted) return;

    bool? updated;
    if (userInfos is Member) {
      updated = await Navigator.of(context).push<bool>(
        MaterialPageRoute(
          builder: (context) => EditMemberProfilePage(member: userInfos),
        ),
      );
    } else if (userInfos is Company) {
      updated = await Navigator.of(context).push<bool>(
        MaterialPageRoute(
          builder: (context) => EditCompanyProfilePage(company: userInfos),
        ),
      );
    }

    // Recharger la page de profil si modification réussie
    if (updated == true) {
      onProfileUpdated?.call();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Material(
          color: Colors.white.withAlpha((0.2 * 255).round()),
          child: InkWell(
            onTap: () => _navigateToEditProfile(context),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withAlpha((0.3 * 255).round()),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.edit_outlined,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'edit'.tr(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
