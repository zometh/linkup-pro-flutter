import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isDark;
  final void Function(String value) onChanged;
  final VoidCallback onSubmitted;
  final VoidCallback onClear;
  final VoidCallback onCancel;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.isDark,
    required this.onChanged,
    required this.onSubmitted,
    required this.onClear,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                onChanged: onChanged,
                onSubmitted: (_) => onSubmitted(),
                style: TextStyle(
                  color: isDark ? Colors.white : AppColors.textPrimary,
                  fontSize: 15,
                ),
                decoration: InputDecoration(
                  hintText: 'search'.tr(),
                  hintStyle: TextStyle(
                    color: isDark ? Colors.white38 : AppColors.textTertiary,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: isDark ? Colors.white38 : AppColors.textTertiary,
                  ),
                  suffixIcon: controller.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: isDark ? Colors.white38 : AppColors.textTertiary,
                            size: 20,
                          ),
                          onPressed: onClear,
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),
          if (focusNode.hasFocus) ...[
            const SizedBox(width: 12),
            TextButton(
              onPressed: onCancel,
              child: Text(
                'cancel'.tr(),
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

