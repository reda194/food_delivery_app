import 'package:equatable/equatable.dart';

enum NotificationType {
  orderUpdate,
  promotion,
  newRestaurant,
  delivery,
  payment,
  system,
  chat,
}

enum NotificationPriority {
  low,
  normal,
  high,
  urgent,
}

class NotificationEntity extends Equatable {
  final String id;
  final String userId;
  final String title;
  final String body;
  final NotificationType type;
  final NotificationPriority priority;
  final Map<String, dynamic>? data;
  final String? imageUrl;
  final String? actionUrl;
  final bool isRead;
  final DateTime createdAt;
  final DateTime? readAt;

  const NotificationEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.type,
    this.priority = NotificationPriority.normal,
    this.data,
    this.imageUrl,
    this.actionUrl,
    this.isRead = false,
    required this.createdAt,
    this.readAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        body,
        type,
        priority,
        data,
        imageUrl,
        actionUrl,
        isRead,
        createdAt,
        readAt,
      ];

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}
