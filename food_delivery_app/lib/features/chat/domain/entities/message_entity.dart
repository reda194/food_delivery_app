import 'package:equatable/equatable.dart';

enum MessageType {
  text,
  image,
  file,
  system,
}

enum MessageStatus {
  sending,
  sent,
  delivered,
  read,
  failed,
}

class MessageEntity extends Equatable {
  final String id;
  final String conversationId;
  final String senderId;
  final String senderName;
  final String? senderImageUrl;
  final String content;
  final MessageType type;
  final MessageStatus status;
  final DateTime timestamp;
  final String? imageUrl;
  final String? fileUrl;
  final String? fileName;
  final bool isMe;

  const MessageEntity({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.senderName,
    this.senderImageUrl,
    required this.content,
    required this.type,
    required this.status,
    required this.timestamp,
    this.imageUrl,
    this.fileUrl,
    this.fileName,
    required this.isMe,
  });

  @override
  List<Object?> get props => [
        id,
        conversationId,
        senderId,
        senderName,
        senderImageUrl,
        content,
        type,
        status,
        timestamp,
        imageUrl,
        fileUrl,
        fileName,
        isMe,
      ];
}
