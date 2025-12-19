import 'package:get_it/get_it.dart';
import 'package:linkup_pro/features/notifications/data/repositories/notification_repository.dart';
import 'package:linkup_pro/features/notifications/domain/entities/notification_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_provider.g.dart';

/// État des notifications
class NotificationsState {
  final List<NotificationEntity> notifications;
  final int unreadCount;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final int currentPage;
  final String? error;

  const NotificationsState({
    this.notifications = const [],
    this.unreadCount = 0,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.currentPage = 1,
    this.error,
  });

  NotificationsState copyWith({
    List<NotificationEntity>? notifications,
    int? unreadCount,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    int? currentPage,
    String? error,
  }) {
    return NotificationsState(
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      error: error,
    );
  }
}

/// Provider principal des notifications
@Riverpod(keepAlive: true)
class Notifications extends _$Notifications {
  final _repository = GetIt.I<NotificationRepository>();

  @override
  NotificationsState build() {
    return const NotificationsState();
  }

  /// Charger les notifications
  Future<void> loadNotifications({bool refresh = false}) async {
    if (state.isLoading) return;

    if (refresh) {
      state = state.copyWith(isLoading: true, error: null);
    } else {
      state = state.copyWith(isLoading: true);
    }

    final result = await _repository.getNotifications(
      page: 1,
      limit: 20,
    );

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure,
      ),
      (response) => state = state.copyWith(
        notifications: response.notifications,
        unreadCount: response.unreadCount,
        isLoading: false,
        hasMore: response.pagination.page < response.pagination.totalPages,
        currentPage: 1,
      ),
    );
  }

  /// Charger plus de notifications
  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;

    state = state.copyWith(isLoadingMore: true);

    final nextPage = state.currentPage + 1;
    final result = await _repository.getNotifications(
      page: nextPage,
      limit: 20,
    );

    result.fold(
      (failure) => state = state.copyWith(
        isLoadingMore: false,
        error: failure,
      ),
      (response) => state = state.copyWith(
        notifications: [...state.notifications, ...response.notifications],
        isLoadingMore: false,
        hasMore: response.pagination.page < response.pagination.totalPages,
        currentPage: nextPage,
      ),
    );
  }

  /// Marquer toutes comme lues
  Future<void> markAllAsRead() async {
    final result = await _repository.markAsRead(markAll: true);

    result.fold(
      (failure) => null,
      (count) {
        final updatedNotifications = state.notifications
            .map((n) => NotificationEntity(
                  id: n.id,
                  title: n.title,
                  message: n.message,
                  type: n.type,
                  isRead: true,
                  createdAt: n.createdAt,
                ))
            .toList();

        state = state.copyWith(
          notifications: updatedNotifications,
          unreadCount: 0,
        );
      },
    );
  }

  /// Marquer une notification comme lue
  Future<void> markAsRead(String notificationId) async {
    final result = await _repository.markOneAsRead(notificationId);

    result.fold(
      (failure) => null,
      (notification) {
        final index = state.notifications.indexWhere((n) => n.id == notificationId);
        if (index != -1) {
          final updatedNotifications = List<NotificationEntity>.from(state.notifications);
          updatedNotifications[index] = notification;

          state = state.copyWith(
            notifications: updatedNotifications,
            unreadCount: state.unreadCount > 0 ? state.unreadCount - 1 : 0,
          );
        }
      },
    );
  }

  /// Supprimer une notification
  Future<void> deleteNotification(String notificationId) async {
    final notification = state.notifications.firstWhere(
      (n) => n.id == notificationId,
      orElse: () => NotificationEntity(
        id: '',
        title: '',
        message: '',
        type: '',
        isRead: true,
        createdAt: DateTime.now(),
      ),
    );

    final result = await _repository.deleteNotification(notificationId);

    result.fold(
      (failure) => null,
      (success) {
        if (success) {
          final updatedNotifications = state.notifications
              .where((n) => n.id != notificationId)
              .toList();

          state = state.copyWith(
            notifications: updatedNotifications,
            unreadCount: !notification.isRead && state.unreadCount > 0
                ? state.unreadCount - 1
                : state.unreadCount,
          );
        }
      },
    );
  }

  /// Supprimer toutes les notifications lues
  Future<void> deleteReadNotifications() async {
    final result = await _repository.deleteReadNotifications();

    result.fold(
      (failure) => null,
      (count) {
        final updatedNotifications = state.notifications
            .where((n) => !n.isRead)
            .toList();

        state = state.copyWith(notifications: updatedNotifications);
      },
    );
  }

  /// Mettre à jour le compteur de notifications non lues
  void updateUnreadCount(int count) {
    state = state.copyWith(unreadCount: count);
  }

  /// Ajouter une nouvelle notification (depuis WebSocket)
  void addNotification(NotificationEntity notification) {
    state = state.copyWith(
      notifications: [notification, ...state.notifications],
      unreadCount: state.unreadCount + 1,
    );
  }
}


