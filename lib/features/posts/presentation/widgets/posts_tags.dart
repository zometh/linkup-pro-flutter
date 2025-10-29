import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_text.dart';

class PostsTags extends StatelessWidget {
  final List<String> tags;
  const PostsTags({super.key, required this.tags});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 8,
        top: 0),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tags.map((tag) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: .15),
                    AppColors.primaryLight.withValues(alpha: .1),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: CustomText(
                text: '#$tag',

                color: AppColors.primary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            );
          }).toList(),
        ),
      );

  }
}
