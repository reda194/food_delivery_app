import 'dart:convert';
import '../../domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.body,
    required super.type,
    super.priority,
    super.data,
    super.imageUrl,
    super.actionUrl,
    super.isRead,
    required super.createdAt,
    super.readAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      type: NotificationType.values.firstWhere(
        (e) => e.toString() == 'NotificationType.${json['type']}',
        orElse: () => NotificationType.system,
      ),
      priority: NotificationPriority.values.firstWhere(
        (e) => e.toString() == 'NotificationPriority.${json['priority']}',
        orElse: () => NotificationPriority.normal,
      ),
      data: json['data'] != null
          ? (json['data'] is String
              ? jsonDecode(json['data'] as String) as Map<String, dynamic>?
              : json['data'] as Map<String, dynamic>?)
          : null,
      imageUrl: json['image_url'] as String?,
      actionUrl: json['action_url'] as String?,
      isRead: json['is_read'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      readAt: json['read_at'] != null
          ? DateTime.parse(json['read_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'body': body,
      'type': type.toString().split('.').last,
      'priority': priority.toString().split('.').last,
      'data': data != null ? jsonEncode(data) : null,
      'image_url': imageUrl,
      'action_url': actionUrl,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
      'read_at': readAt?.toIso8601String(),
    };
  }

  factory NotificationModel.fromFcmMessage(Map<String, dynamic> message) {
    final notification = message['notification'] as Map<String, dynamic>?;
    final data = message['data'] as Map<String, dynamic>?;

    return NotificationModel(
      id: data?['notification_id'] as String? ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      userId: data?['user_id'] as String? ?? '',
      title: notification?['title'] as String? ?? 'New Notification',
      body: notification?['body'] as String? ?? '',
      type: NotificationType.values.firstWhere(
        (e) =>
            e.toString() == 'NotificationType.${data?['type'] ?? 'system'}',
        orElse: () => NotificationType.system,
      ),
      priority: NotificationPriority.values.firstWhere(
        (e) => e.toString() ==
            'NotificationPriority.${data?['priority'] ?? 'normal'}',
        orElse: () => NotificationPriority.normal,
      ),
      data: data,
      imageUrl: notification?['image'] as String?,
      actionUrl: data?['action_url'] as String?,
      isRead: false,
      createdAt: DateTime.now(),
    );
  }
}
