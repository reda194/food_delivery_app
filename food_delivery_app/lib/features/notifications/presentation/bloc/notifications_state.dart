import 'package:equatable/equatable.dart';
import '../../domain/entities/notification_entity.dart';

abstract class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class NotificationsInitial extends NotificationsState {
  const NotificationsInitial();
}

/// Loading notifications
class NotificationsLoading extends NotificationsState {
  const NotificationsLoading();
}

/// Notifications loaded
class NotificationsLoaded extends NotificationsState {
  final List<NotificationEntity> notifications;
  final int unreadCount;
  final bool hasMore;
  final bool isLoadingMore;
  final bool permissionsGranted;

  const NotificationsLoaded({
    required this.notifications,
    required this.unreadCount,
    this.hasMore = true,
    this.isLoadingMore = false,
    this.permissionsGranted = false,
  });

  @override
  List<Object?> get props => [
        notifications,
        unreadCount,
        hasMore,
        isLoadingMore,
        permissionsGranted,
      ];

  NotificationsLoaded copyWith({
    List<NotificationEntity>? notifications,
    int? unreadCount,
    bool? hasMore,
    bool? isLoadingMore,
    bool? permissionsGranted,
  }) {
    return NotificationsLoaded(
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      permissionsGranted: permissionsGranted ?? this.permissionsGranted,
    );
  }
}

/// Notifications error
class NotificationsError extends NotificationsState {
  final String message;

  const NotificationsError({required this.message});

  @override
  List<Object?> get props => [message];
}
