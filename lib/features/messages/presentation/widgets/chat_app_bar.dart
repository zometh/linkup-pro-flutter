import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_text.dart';

class ChatAppBar extends StatelessWidget {
  const ChatAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final List<String> filters = ["Tous", "Lus", "Non lus"];
    return SliverAppBar(
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(FontAwesomeIcons.magnifyingGlass, size: 20),
        ),
      ],
      title: Text("Messages"),
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 0,
      pinned: false,
      floating: true,
      snap: true,
      expandedHeight: 60,

      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(45),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 45,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: ListView.separated(
                  separatorBuilder: (_, index) =>
                  const SizedBox(width: 6),
                  scrollDirection: Axis.horizontal,
                  itemCount: filters.length,
                  itemBuilder: (context, index) {
                    final item = filters[index];
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: index == 0
                            ? AppColors.primary
                            : (isDark
                            ? AppColors.darkCard
                            : Colors.white),
                        borderRadius: BorderRadius.circular(30),
                        border: index == 0
                            ? null
                            : Border.all(
                          color: isDark
                              ? Colors.white12
                              : const Color(0xFFE5E7EB),
                        ),
                      ),
                      child: CustomText(
                        text: item,
                        fontSize: 13,
                        fontWeight: index == 0
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: index == 0
                            ? Colors.white
                            : (isDark
                            ? Colors.white70
                            : AppColors.textSecondary),
                      ),
                    );
                  },
                ),
              ),
            ),
            Builder(
              builder: (context) {
                final hairline =
                    1 / MediaQuery.of(context).devicePixelRatio;
                return Divider(
                  height: hairline,
                  thickness: hairline,
                  color: Theme.of(context).dividerColor.withAlpha(80),
                );
              },
            ),
          ],
        ),
      ),
      // actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))],
    );
  }
}
