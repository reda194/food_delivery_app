import 'package:equatable/equatable.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object?> get props => [];
}

/// Load notifications
class LoadNotificationsEvent extends NotificationsEvent {
  const LoadNotificationsEvent();
}

/// Load more notifications (pagination)
class LoadMoreNotificationsEvent extends NotificationsEvent {
  const LoadMoreNotificationsEvent();
}

/// Refresh notifications
class RefreshNotificationsEvent extends NotificationsEvent {
  const RefreshNotificationsEvent();
}

/// New notification received (real-time)
class NotificationReceivedEvent extends NotificationsEvent {
  final Map<String, dynamic> notificationData;

  const NotificationReceivedEvent({required this.notificationData});

  @override
  List<Object?> get props => [notificationData];
}

/// Mark notification as read
class MarkAsReadEvent extends NotificationsEvent {
  final String notificationId;

  const MarkAsReadEvent({required this.notificationId});

  @override
  List<Object?> get props => [notificationId];
}

/// Mark all notifications as read
class MarkAllAsReadEvent extends NotificationsEvent {
  const MarkAllAsReadEvent();
}

/// Delete notification
class DeleteNotificationEvent extends NotificationsEvent {
  final String notificationId;

  const DeleteNotificationEvent({required this.notificationId});

  @override
  List<Object?> get props => [notificationId];
}

/// Delete all notifications
class DeleteAllNotificationsEvent extends NotificationsEvent {
  const DeleteAllNotificationsEvent();
}

/// Request notification permissions
class RequestPermissionsEvent extends NotificationsEvent {
  const RequestPermissionsEvent();
}

/// Save FCM token
class SaveFcmTokenEvent extends NotificationsEvent {
  final String token;

  const SaveFcmTokenEvent({required this.token});

  @override
  List<Object?> get props => [token];
}
