import 'package:flutter/material.dart';

import '../../domain/enums/post_type.dart';


class PostTypeButton extends StatelessWidget {
  final Function(PostType type) onChanged;
  final PostType type;
   PostType selectedPostType;
  final String label;
  final IconData icon;
   PostTypeButton({super.key, required this.type, required this.label, required this.icon, required this.onChanged,  required this.selectedPostType});

  @override
  Widget build(BuildContext context) {

      final isSelected = selectedPostType == type;
      final theme = Theme.of(context);

      return GestureDetector(
        onTap: () => onChanged(type) /*setState(() => _selectedPostType = type)*/,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? theme.colorScheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(26),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? Colors.white : theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? Colors.white : theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

