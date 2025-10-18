import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/conversation_entity.dart';
import '../entities/message_entity.dart';

abstract class ChatRepository {
  /// Send a text message
  Future<Either<Failure, MessageEntity>> sendMessage({
    required String conversationId,
    required String content,
    required MessageType type,
    String? imageUrl,
    String? fileUrl,
    String? fileName,
  });

  /// Get messages for a conversation
  Future<Either<Failure, List<MessageEntity>>> getMessages({
    required String conversationId,
    int limit = 50,
    String? beforeMessageId,
  });

  /// Subscribe to real-time messages
  Stream<Either<Failure, MessageEntity>> subscribeToMessages({
    required String conversationId,
  });

  /// Mark messages as read
  Future<Either<Failure, void>> markAsRead({
    required String conversationId,
    required List<String> messageIds,
  });

  /// Send typing indicator
  Future<Either<Failure, void>> sendTypingIndicator({
    required String conversationId,
    required bool isTyping,
  });

  /// Subscribe to typing indicators
  Stream<Either<Failure, bool>> subscribeToTypingIndicator({
    required String conversationId,
  });

  /// Get conversation by order ID
  Future<Either<Failure, ConversationEntity>> getConversationByOrderId({
    required String orderId,
  });

  /// Create a new conversation
  Future<Either<Failure, ConversationEntity>> createConversation({
    required String orderId,
    required String driverId,
    required String customerId,
  });

  /// Upload image
  Future<Either<Failure, String>> uploadImage({
    required String conversationId,
    required String imagePath,
  });

  /// Upload file
  Future<Either<Failure, Map<String, String>>> uploadFile({
    required String conversationId,
    required String filePath,
  });
}
