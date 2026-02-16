class NotificationEntity {
  final String id;
  final String title;
  final String message;
  final String type;
  final bool isRead;
  final DateTime createdAt;

  NotificationEntity({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationEntity.fromJson(Map<String, dynamic> json) {
    return NotificationEntity(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? 'GENERAL',
      isRead: json['isRead'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }
}

class NotificationPagination {
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  NotificationPagination({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  factory NotificationPagination.fromJson(Map<String, dynamic> json) {
    return NotificationPagination(
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 20,
      total: json['total'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
    );
  }
}

class NotificationsResponse {
  final List<NotificationEntity> notifications;
  final NotificationPagination pagination;
  final int unreadCount;

  NotificationsResponse({
    required this.notifications,
    required this.pagination,
    required this.unreadCount,
  });

  factory NotificationsResponse.fromJson(Map<String, dynamic> json) {
    return NotificationsResponse(
      notifications: (json['notifications'] as List?)
              ?.map((e) => NotificationEntity.fromJson(e))
              .toList() ??
          [],
      pagination: NotificationPagination.fromJson(json['pagination'] ?? {}),
      unreadCount: json['unreadCount'] ?? 0,
    );
  }
}

