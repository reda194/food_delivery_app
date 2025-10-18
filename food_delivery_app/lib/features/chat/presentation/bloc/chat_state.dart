import 'package:equatable/equatable.dart';
import '../../domain/entities/conversation_entity.dart';
import '../../domain/entities/message_entity.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class ChatInitial extends ChatState {
  const ChatInitial();
}

/// Loading conversation
class ChatLoading extends ChatState {
  const ChatLoading();
}

/// Conversation loaded with messages
class ChatLoaded extends ChatState {
  final ConversationEntity conversation;
  final List<MessageEntity> messages;
  final bool isOtherUserTyping;
  final bool hasMoreMessages;
  final bool isLoadingMore;

  const ChatLoaded({
    required this.conversation,
    required this.messages,
    this.isOtherUserTyping = false,
    this.hasMoreMessages = true,
    this.isLoadingMore = false,
  });

  @override
  List<Object?> get props => [
        conversation,
        messages,
        isOtherUserTyping,
        hasMoreMessages,
        isLoadingMore,
      ];

  ChatLoaded copyWith({
    ConversationEntity? conversation,
    List<MessageEntity>? messages,
    bool? isOtherUserTyping,
    bool? hasMoreMessages,
    bool? isLoadingMore,
  }) {
    return ChatLoaded(
      conversation: conversation ?? this.conversation,
      messages: messages ?? this.messages,
      isOtherUserTyping: isOtherUserTyping ?? this.isOtherUserTyping,
      hasMoreMessages: hasMoreMessages ?? this.hasMoreMessages,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

/// Message sending in progress
class MessageSending extends ChatState {
  final String tempMessageId;
  final String content;

  const MessageSending({
    required this.tempMessageId,
    required this.content,
  });

  @override
  List<Object?> get props => [tempMessageId, content];
}

/// Chat error
class ChatError extends ChatState {
  final String message;

  const ChatError({required this.message});

  @override
  List<Object?> get props => [message];
}
