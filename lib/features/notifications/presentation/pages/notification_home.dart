import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/core/widgets/custom_text.dart';
import 'package:linkup_pro/features/notifications/presentation/providers/notification_provider.dart';
import 'package:linkup_pro/features/notifications/presentation/widgets/notification_card.dart';


class NotificationHome extends ConsumerStatefulWidget {
  const NotificationHome({super.key});

  @override
  ConsumerState<NotificationHome> createState() => _NotificationHomeState();
}

class _NotificationHomeState extends ConsumerState<NotificationHome> {
  @override
  void initState() {
    super.initState();
    // Charger les notifications au démarrage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationsProvider.notifier).loadNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final notificationsState = ref.watch(notificationsProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
        elevation: 0,
        title: CustomText(
          text: 'Notifications',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : AppColors.textPrimary,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : AppColors.textPrimary,
          ),
          onPressed: () => GoRouter.of(context).pop(),
        ),
        actions: [
          if (notificationsState.unreadCount > 0)
            TextButton(
              onPressed: () {
                ref.read(notificationsProvider.notifier).markAllAsRead();
              },
              child: Text(
                'Tout marquer lu',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 13,
                ),
              ),
            ),
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
            onSelected: (value) {
              if (value == 'delete_read') {
                _showDeleteConfirmation(context);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'delete_read',
                child: Row(
                  children: [
                    Icon(Icons.delete_sweep, size: 20),
                    SizedBox(width: 8),
                    Text('Supprimer les lues'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _buildBody(isDark, notificationsState),
    );
  }

  Widget _buildBody(bool isDark, NotificationsState notificationsState) {
    if (notificationsState.isLoading && notificationsState.notifications.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (notificationsState.error != null && notificationsState.notifications.isEmpty) {
      return _buildErrorState(isDark, notificationsState.error!);
    }

    if (notificationsState.notifications.isEmpty) {
      return _buildEmptyState(isDark);
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(notificationsProvider.notifier).loadNotifications(refresh: true);
      },
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollEndNotification &&
              notification.metrics.extentAfter < 200) {
            ref.read(notificationsProvider.notifier).loadMore();
          }
          return false;
        },
        child: ListView.builder(
          itemCount: notificationsState.notifications.length +
              (notificationsState.isLoadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == notificationsState.notifications.length) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final notification = notificationsState.notifications[index];
            return NotificationCard(
              notification: notification,
              isDark: isDark,
              onTap: () {
                if (!notification.isRead) {
                  ref.read(notificationsProvider.notifier).markAsRead(notification.id);
                }
                // TODO: Naviguer vers le contenu lié à la notification
              },
              onDelete: () {
                ref.read(notificationsProvider.notifier).deleteNotification(notification.id);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 64,
            color: isDark ? Colors.white24 : AppColors.textTertiary,
          ),
          const SizedBox(height: 16),
          CustomText(
            text: 'Aucune notification',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white70 : AppColors.textPrimary,
          ),
          const SizedBox(height: 8),
          CustomText(
            text: 'Vous n\'avez pas encore de notifications',
            fontSize: 14,
            color: isDark ? Colors.white38 : AppColors.textSecondary,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(bool isDark, String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red.shade300,
          ),
          const SizedBox(height: 16),
          CustomText(
            text: 'Erreur de chargement',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white70 : AppColors.textPrimary,
          ),
          const SizedBox(height: 8),
          CustomText(
            text: error,
            fontSize: 14,
            color: isDark ? Colors.white38 : AppColors.textSecondary,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ref.read(notificationsProvider.notifier).loadNotifications(refresh: true);
            },
            child: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer les notifications lues'),
        content: const Text(
          'Voulez-vous supprimer toutes les notifications que vous avez déjà lues ?',
        ),
        actions: [
          TextButton(
            onPressed: () => GoRouter.of(context).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              GoRouter.of(context).pop();
              ref.read(notificationsProvider.notifier).deleteReadNotifications();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}
