import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/notification_entity.dart';

abstract class NotificationsRepository {
  /// Get all notifications for current user
  Future<Either<Failure, List<NotificationEntity>>> getNotifications({
    int limit = 50,
    int offset = 0,
  });

  /// Get unread notifications count
  Future<Either<Failure, int>> getUnreadCount();

  /// Mark notification as read
  Future<Either<Failure, void>> markAsRead(String notificationId);

  /// Mark all notifications as read
  Future<Either<Failure, void>> markAllAsRead();

  /// Delete notification
  Future<Either<Failure, void>> deleteNotification(String notificationId);

  /// Delete all notifications
  Future<Either<Failure, void>> deleteAllNotifications();

  /// Subscribe to real-time notifications
  Stream<Either<Failure, NotificationEntity>> subscribeToNotifications();

  /// Save FCM token
  Future<Either<Failure, void>> saveFcmToken(String token);

  /// Delete FCM token
  Future<Either<Failure, void>> deleteFcmToken();

  /// Request notification permissions
  Future<Either<Failure, bool>> requestPermissions();

  /// Check if notifications are enabled
  Future<Either<Failure, bool>> areNotificationsEnabled();
}
