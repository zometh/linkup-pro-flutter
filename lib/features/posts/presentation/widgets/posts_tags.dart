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
            return CustomText(
                text: '#$tag',

                color: AppColors.primary,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              //),
            );
          }).toList(),
        ),
      );

  }
}
