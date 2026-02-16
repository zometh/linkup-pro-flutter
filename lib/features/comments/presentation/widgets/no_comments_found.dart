import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class NoCommentsFound extends StatelessWidget {
  const NoCommentsFound({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withAlpha((0.05 * 255).round())
                  : Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.chat_bubble_outline_rounded,
              size: 30,
              color: isDark ? Colors.white38 : Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'no_comments_found'.tr(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: isDark ? Colors.white70 : Colors.grey.shade600,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
