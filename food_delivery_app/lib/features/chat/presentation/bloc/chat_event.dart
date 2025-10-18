import 'package:equatable/equatable.dart';
import '../../domain/entities/message_entity.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

/// Load conversation and messages
class LoadConversationEvent extends ChatEvent {
  final String orderId;

  const LoadConversationEvent({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

/// Send a text message
class SendTextMessageEvent extends ChatEvent {
  final String content;

  const SendTextMessageEvent({required this.content});

  @override
  List<Object?> get props => [content];
}

/// Send an image message
class SendImageMessageEvent extends ChatEvent {
  final String imagePath;

  const SendImageMessageEvent({required this.imagePath});

  @override
  List<Object?> get props => [imagePath];
}

/// Send a file message
class SendFileMessageEvent extends ChatEvent {
  final String filePath;

  const SendFileMessageEvent({required this.filePath});

  @override
  List<Object?> get props => [filePath];
}

/// New message received (real-time)
class MessageReceivedEvent extends ChatEvent {
  final MessageEntity message;

  const MessageReceivedEvent({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Mark messages as read
class MarkMessagesAsReadEvent extends ChatEvent {
  final List<String> messageIds;

  const MarkMessagesAsReadEvent({required this.messageIds});

  @override
  List<Object?> get props => [messageIds];
}

/// User started typing
class StartTypingEvent extends ChatEvent {
  const StartTypingEvent();
}

/// User stopped typing
class StopTypingEvent extends ChatEvent {
  const StopTypingEvent();
}

/// Other user typing indicator received
class TypingIndicatorReceivedEvent extends ChatEvent {
  final bool isTyping;

  const TypingIndicatorReceivedEvent({required this.isTyping});

  @override
  List<Object?> get props => [isTyping];
}

/// Load more messages (pagination)
class LoadMoreMessagesEvent extends ChatEvent {
  const LoadMoreMessagesEvent();
}
