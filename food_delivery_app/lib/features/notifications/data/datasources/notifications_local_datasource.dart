import 'package:hive_flutter/hive_flutter.dart';
import '../models/notification_model.dart';

abstract class NotificationsLocalDataSource {
  Future<void> cacheNotifications(List<NotificationModel> notifications);
  Future<List<NotificationModel>> getCachedNotifications();
  Future<void> clearCache();
  Future<void> cacheNotification(NotificationModel notification);
  Future<void> markAsRead(String notificationId);
  Future<void> deleteNotification(String notificationId);
}

class NotificationsLocalDataSourceImpl implements NotificationsLocalDataSource {
  static const String notificationsBoxName = 'notifications';

  Box<Map<dynamic, dynamic>>? _notificationsBox;

  Future<void> init() async {
    if (!Hive.isBoxOpen(notificationsBoxName)) {
      _notificationsBox =
          await Hive.openBox<Map<dynamic, dynamic>>(notificationsBoxName);
    } else {
      _notificationsBox = Hive.box<Map<dynamic, dynamic>>(notificationsBoxName);
    }
  }

  @override
  Future<void> cacheNotifications(
      List<NotificationModel> notifications) async {
    await init();

    for (final notification in notifications) {
      await _notificationsBox?.put(notification.id, notification.toJson());
    }
  }

  @override
  Future<List<NotificationModel>> getCachedNotifications() async {
    await init();

    final values = _notificationsBox?.values.toList() ?? [];

    return values
        .map((json) =>
            NotificationModel.fromJson(Map<String, dynamic>.from(json as Map)))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt)); // Sort by newest
  }

  @override
  Future<void> clearCache() async {
    await init();
    await _notificationsBox?.clear();
  }

  @override
  Future<void> cacheNotification(NotificationModel notification) async {
    await init();
    await _notificationsBox?.put(notification.id, notification.toJson());
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    await init();

    final notificationData = _notificationsBox?.get(notificationId);
    if (notificationData != null) {
      final notification = NotificationModel.fromJson(
        Map<String, dynamic>.from(notificationData as Map),
      );

      final updatedNotification = NotificationModel(
        id: notification.id,
        userId: notification.userId,
        title: notification.title,
        body: notification.body,
        type: notification.type,
        priority: notification.priority,
        data: notification.data,
        imageUrl: notification.imageUrl,
        actionUrl: notification.actionUrl,
        isRead: true,
        createdAt: notification.createdAt,
        readAt: DateTime.now(),
      );

      await _notificationsBox?.put(notificationId, updatedNotification.toJson());
    }
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    await init();
    await _notificationsBox?.delete(notificationId);
  }
}
