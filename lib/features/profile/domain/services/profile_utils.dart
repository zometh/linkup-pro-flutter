import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../presentation/widgets/profile_more_option.dart';
class ProfileUtils {
  static  void showMoreOptions(BuildContext context){

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