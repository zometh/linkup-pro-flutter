
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linkup_pro/core/widgets/my_animated_flipcounter.dart';

class ProfileStats extends StatelessWidget {
  final int count;
  final String label;
  final VoidCallback onTap;

   const ProfileStats({super.key,
    required this.count,
    required this.label,
    required this.onTap,

  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            MyAnimatedFlipcounter(value: count),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                color: isDarkMode ? Colors.white54 : Colors.black54,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class GlobalProfileStats extends StatelessWidget {
  final int following;
  final int followers;
  const GlobalProfileStats({super.key, this.following = 0, this.followers = 0});

  @override
  Widget build(BuildContext context) {
    return  Row(
      spacing: 20,
      mainAxisSize: MainAxisSize.max,
      children: [
        ProfileStats(
          count: following,
          label: 'following'.tr(),
          onTap: () {},
        ),
        ProfileStats(
          count: followers,
          label: 'followers'.tr(),
          onTap: () {},
        ),
      ],
    );
  }
}
