import 'package:equatable/equatable.dart';
import 'message_entity.dart';

class ConversationEntity extends Equatable {
  final String id;
  final String orderId;
  final String driverId;
  final String driverName;
  final String? driverImageUrl;
  final String customerId;
  final String customerName;
  final String? customerImageUrl;
  final MessageEntity? lastMessage;
  final int unreadCount;
  final DateTime lastActivity;
  final bool isTyping;

  const ConversationEntity({
    required this.id,
    required this.orderId,
    required this.driverId,
    required this.driverName,
    this.driverImageUrl,
    required this.customerId,
    required this.customerName,
    this.customerImageUrl,
    this.lastMessage,
    required this.unreadCount,
    required this.lastActivity,
    this.isTyping = false,
  });

  @override
  List<Object?> get props => [
        id,
        orderId,
        driverId,
        driverName,
        driverImageUrl,
        customerId,
        customerName,
        customerImageUrl,
        lastMessage,
        unreadCount,
        lastActivity,
        isTyping,
      ];
}
