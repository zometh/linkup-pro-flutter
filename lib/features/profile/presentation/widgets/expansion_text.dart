import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/core/widgets/custom_text.dart';
import 'package:linkup_pro/main.dart';

class ExpansionText extends StatefulWidget {
  final String text;
  final bool isProfileBio;
  const ExpansionText({
    super.key,
    required this.text,
    this.isProfileBio = false,
  });

  @override
  State<ExpansionText> createState() => _ExpansionTextState();
}

class _ExpansionTextState extends State<ExpansionText> {
  String get content => widget.text;
  bool get shouldShowMore => content.length > 200;
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    return Padding(
      padding: .symmetric(horizontal: widget.isProfileBio ? 0 : 16),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          AnimatedCrossFade(
            firstChild: CustomText(
              text: content,
              fontFamily: widget.isProfileBio ? "Roboto" : "Poppins",
              fontSize: widget.isProfileBio ? 14 : 15,

              color: isDark
                  ? Colors.white.withValues(alpha: .9)
                  : AppColors.textPrimary,

              maxLines: 4,
              overflow: .ellipsis,
            ),
            secondChild: CustomText(
              text: content,
              fontFamily: widget.isProfileBio ? "Roboto" : "Poppins",
              fontSize: widget.isProfileBio ? 14 : 15,

              color: isDark
                  ? Colors.white.withValues(alpha: .9)
                  : AppColors.textPrimary,
            ),
            crossFadeState: _isExpanded
                ? .showSecond
                : .showFirst,
            duration: const Duration(milliseconds: 300),
          ),
          if (shouldShowMore) ...[
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              child: CustomText(
                text: _isExpanded ? 'show_less'.tr() : 'show_more'.tr(),

                color: AppColors.primary,
                fontWeight: widget.isProfileBio ? .w300 : .w600,
                fontSize: 13,
              ),
            ),
          ],
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
