import '../../domain/entities/conversation_entity.dart';
import 'message_model.dart';

class ConversationModel extends ConversationEntity {
  const ConversationModel({
    required super.id,
    required super.orderId,
    required super.driverId,
    required super.driverName,
    super.driverImageUrl,
    required super.customerId,
    required super.customerName,
    super.customerImageUrl,
    super.lastMessage,
    required super.unreadCount,
    required super.lastActivity,
    super.isTyping,
  });

  factory ConversationModel.fromJson(
      Map<String, dynamic> json, String currentUserId) {
    return ConversationModel(
      id: json['id'] as String,
      orderId: json['order_id'] as String,
      driverId: json['driver_id'] as String,
      driverName: json['driver_name'] as String? ?? '',
      driverImageUrl: json['driver_image_url'] as String?,
      customerId: json['customer_id'] as String,
      customerName: json['customer_name'] as String? ?? '',
      customerImageUrl: json['customer_image_url'] as String?,
      lastMessage: json['last_message'] != null
          ? MessageModel.fromJson(
              json['last_message'] as Map<String, dynamic>, currentUserId)
          : null,
      unreadCount: json['unread_count'] as int? ?? 0,
      lastActivity: DateTime.parse(json['last_activity'] as String),
      isTyping: json['is_typing'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'driver_id': driverId,
      'driver_name': driverName,
      'driver_image_url': driverImageUrl,
      'customer_id': customerId,
      'customer_name': customerName,
      'customer_image_url': customerImageUrl,
      'unread_count': unreadCount,
      'last_activity': lastActivity.toIso8601String(),
      'is_typing': isTyping,
    };
  }
}
