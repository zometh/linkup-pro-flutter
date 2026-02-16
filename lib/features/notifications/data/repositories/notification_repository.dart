import 'package:dartz/dartz.dart';
import 'package:linkup_pro/core/network/api/api_client.dart';
import 'package:linkup_pro/core/network/api/network_exception.dart';
import 'package:linkup_pro/features/notifications/domain/entities/notification_entity.dart';

class NotificationRepository {
  final ApiClient _apiClient;

  NotificationRepository(this._apiClient);

  /// Récupérer les notifications
  Future<Either<String, NotificationsResponse>> getNotifications({
    int page = 1,
    int limit = 20,
    bool unreadOnly = false,
  }) async {
    try {
      final response = await _apiClient.getOne(
        '/notifications',
        queryParams: {
          'page': page.toString(),
          'limit': limit.toString(),
          'unreadOnly': unreadOnly.toString(),
        },
      );

      return Right(NotificationsResponse.fromJson(response));
    } on NetworkException catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left(e.toString());
    }
  }

  /// Récupérer le nombre de notifications non lues
  Future<Either<String, int>> getUnreadCount() async {
    try {
      final response = await _apiClient.getOne('/notifications/unread-count');
      return Right(response['unreadCount'] ?? 0);
    } on NetworkException catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left(e.toString());
    }
  }

  /// Marquer des notifications comme lues
  Future<Either<String, int>> markAsRead({
    List<String>? notificationIds,
    bool markAll = false,
  }) async {
    try {
      final response = await _apiClient.post(
        '/notifications/mark-read',
        data: {
          if (notificationIds != null) 'notificationIds': notificationIds,
          'markAll': markAll,
        },
      );

      return Right(response['updated'] ?? 0);
    } on NetworkException catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left(e.toString());
    }
  }

  /// Marquer une notification comme lue
  Future<Either<String, NotificationEntity>> markOneAsRead(String notificationId) async {
    try {
      final response = await _apiClient.post(
        '/notifications/$notificationId/read',
        data: {},
      );

      return Right(NotificationEntity.fromJson(response));
    } on NetworkException catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left(e.toString());
    }
  }

  /// Supprimer une notification
  Future<Either<String, bool>> deleteNotification(String notificationId) async {
    try {
      final response = await _apiClient.delete('/notifications/$notificationId');
      return Right(response['success'] ?? false);
    } on NetworkException catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left(e.toString());
    }
  }

  /// Supprimer toutes les notifications lues
  Future<Either<String, int>> deleteReadNotifications() async {
    try {
      final response = await _apiClient.delete('/notifications/read/all');
      return Right(response['deleted'] ?? 0);
    } on NetworkException catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left(e.toString());
    }
  }
}

