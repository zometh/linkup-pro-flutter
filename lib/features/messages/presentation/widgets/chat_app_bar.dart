import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:linkup_pro/features/messages/presentation/widgets/new_conversation_user_list.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_text.dart';

class ChatAppBar extends StatefulWidget {
  final int selectedFilterIndex;
  final Function(int) onFilterChanged;
  final TextEditingController searchController;

  const ChatAppBar({
    super.key,
    required this.selectedFilterIndex,
    required this.onFilterChanged,
    required this.searchController,
  });

  @override
  State<ChatAppBar> createState() => _ChatAppBarState();
}

class _ChatAppBarState extends State<ChatAppBar> {
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final List<String> filters = ["Tous", "Lus", "Non lus"];
    return SliverAppBar(
      actions: _isSearching
          ? null
          : [
              IconButton(
                onPressed: () {
                  setState(() {
                    _isSearching = true;
                  });
                },
                icon: const Icon(FontAwesomeIcons.magnifyingGlass, size: 20),
              ),
              IconButton(
                onPressed: () => _openFreindsList(context),
                icon: const Icon(FontAwesomeIcons.plus, size: 20),
              ),
            ],
      title: _isSearching
          ? TextField(
              controller: widget.searchController,
              autofocus: true,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
                fontSize: 16,
              ),
              decoration: InputDecoration(
                hintText: 'Rechercher une conversation...',
                hintStyle: TextStyle(
                  color: isDark ? Colors.grey[500] : Colors.grey[600],
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            )
          : const Text("Messages"),
      leading: _isSearching
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                setState(() {
                  _isSearching = false;
                  widget.searchController.clear();
                });
              },
            )
          : null,
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
            if (!_isSearching)
              SizedBox(
                height: 45,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: ListView.separated(
                    separatorBuilder: (_, index) => const SizedBox(width: 6),
                    scrollDirection: Axis.horizontal,
                    itemCount: filters.length,
                    itemBuilder: (context, index) {
                      final item = filters[index];
                      final isSelected = widget.selectedFilterIndex == index;
                      return GestureDetector(
                        onTap: () => widget.onFilterChanged(index),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : (isDark ? AppColors.darkCard : Colors.white),
                            borderRadius: BorderRadius.circular(30),
                            border: isSelected
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
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w500,
                            color: isSelected
                                ? Colors.white
                                : (isDark
                                      ? Colors.white70
                                      : AppColors.textSecondary),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            Builder(
              builder: (context) {
                final hairline = 1 / MediaQuery.of(context).devicePixelRatio;
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
    );
  }

  _openFreindsList(BuildContext context) async {
    await showModalBottomSheet(
      showDragHandle: true,

      context: context,
      builder: (_) {
        return const NewConversationUserList();
      },
    );
  }
}
