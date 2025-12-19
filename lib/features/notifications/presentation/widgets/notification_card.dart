import 'package:flutter/material.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/core/widgets/custom_text.dart';
import 'package:linkup_pro/features/notifications/domain/entities/notification_entity.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationCard extends StatelessWidget {
  final NotificationEntity notification;
  final bool isDark;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.isDark,
    this.onTap,
    this.onDelete,
  });

  IconData _getIconForType(String type) {
    switch (type.toUpperCase()) {
      case 'LIKE':
        return Icons.favorite;
      case 'COMMENT':
        return Icons.comment;
      case 'FOLLOW':
        return Icons.person_add;
      case 'MESSAGE':
        return Icons.message;
      case 'JOB':
        return Icons.work;
      case 'APPLICATION':
        return Icons.assignment;
      default:
        return Icons.notifications;
    }
  }

  Color _getColorForType(String type) {
    switch (type.toUpperCase()) {
      case 'LIKE':
        return Colors.red;
      case 'COMMENT':
        return Colors.blue;
      case 'FOLLOW':
        return AppColors.primary;
      case 'MESSAGE':
        return Colors.green;
      case 'JOB':
        return Colors.orange;
      case 'APPLICATION':
        return Colors.purple;
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final iconColor = _getColorForType(notification.type);

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete?.call(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: notification.isRead
                ? (isDark ? AppColors.darkSurface : Colors.white)
                : (isDark
                    ? AppColors.primary.withOpacity(0.1)
                    : AppColors.primary.withOpacity(0.05)),
            border: Border(
              bottom: BorderSide(
                color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
              ),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icône
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getIconForType(notification.type),
                  color: iconColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),

              // Contenu
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: notification.title,
                      fontSize: 14,
                      fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.w600,
                      color: isDark ? Colors.white : AppColors.textPrimary,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 4),
                    CustomText(
                      text: notification.message,
                      fontSize: 13,
                      color: isDark ? Colors.white54 : AppColors.textSecondary,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 6),
                    CustomText(
                      text: timeago.format(notification.createdAt, locale: 'fr'),
                      fontSize: 11,
                      color: isDark ? Colors.white38 : AppColors.textTertiary,
                    ),
                  ],
                ),
              ),

              // Indicateur non lu
              if (!notification.isRead)
                Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

