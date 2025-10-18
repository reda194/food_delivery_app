import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../core/services/realtime_service.dart';
import '../../domain/entities/message_entity.dart';
import '../models/conversation_model.dart';
import '../models/message_model.dart';

abstract class ChatRemoteDataSource {
  Future<MessageModel> sendMessage({
    required String conversationId,
    required String senderId,
    required String senderName,
    String? senderImageUrl,
    required String content,
    required MessageType type,
    String? imageUrl,
    String? fileUrl,
    String? fileName,
  });

  Future<List<MessageModel>> getMessages({
    required String conversationId,
    required String currentUserId,
    int limit = 50,
    String? beforeMessageId,
  });

  Stream<Either<Failure, MessageModel>> subscribeToMessages({
    required String conversationId,
    required String currentUserId,
  });

  Future<void> markAsRead({
    required String conversationId,
    required List<String> messageIds,
  });

  Future<void> sendTypingIndicator({
    required String conversationId,
    required String userId,
    required bool isTyping,
  });

  Stream<Either<Failure, bool>> subscribeToTypingIndicator({
    required String conversationId,
    required String currentUserId,
  });

  Future<ConversationModel> getConversationByOrderId({
    required String orderId,
    required String currentUserId,
  });

  Future<ConversationModel> createConversation({
    required String orderId,
    required String driverId,
    required String customerId,
    required String currentUserId,
  });

  Future<String> uploadImage({
    required String conversationId,
    required String imagePath,
  });

  Future<Map<String, String>> uploadFile({
    required String conversationId,
    required String filePath,
  });
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final SupabaseService supabaseService;
  final RealtimeService realtimeService;

  ChatRemoteDataSourceImpl({
    required this.supabaseService,
    required this.realtimeService,
  });

  @override
  Future<MessageModel> sendMessage({
    required String conversationId,
    required String senderId,
    required String senderName,
    String? senderImageUrl,
    required String content,
    required MessageType type,
    String? imageUrl,
    String? fileUrl,
    String? fileName,
  }) async {
    try {
      final messageData = {
        'conversation_id': conversationId,
        'sender_id': senderId,
        'sender_name': senderName,
        'sender_image_url': senderImageUrl,
        'content': content,
        'type': type.toString().split('.').last,
        'status': MessageStatus.sent.toString().split('.').last,
        'timestamp': DateTime.now().toIso8601String(),
        'image_url': imageUrl,
        'file_url': fileUrl,
        'file_name': fileName,
      };

      final response = await supabaseService.client
          .from('messages')
          .insert(messageData)
          .select()
          .single();

      return MessageModel.fromJson(response as Map<String, dynamic>, senderId);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<MessageModel>> getMessages({
    required String conversationId,
    required String currentUserId,
    int limit = 50,
    String? beforeMessageId,
  }) async {
    try {
      dynamic query = supabaseService.client
          .from('messages')
          .select()
          .eq('conversation_id', conversationId)
          .order('timestamp', ascending: false)
          .limit(limit);

      if (beforeMessageId != null) {
        // Get timestamp of the before message
        final beforeMessage = await supabaseService.client
            .from('messages')
            .select('timestamp')
            .eq('id', beforeMessageId)
            .single();

        query = query.lt('timestamp', beforeMessage['timestamp']);
      }

      final response = await query;

      return (response as List)
          .map((json) =>
              MessageModel.fromJson(json as Map<String, dynamic>, currentUserId))
          .toList()
          .reversed
          .toList(); // Reverse to show oldest first
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Stream<Either<Failure, MessageModel>> subscribeToMessages({
    required String conversationId,
    required String currentUserId,
  }) {
    try {
      final stream = realtimeService.subscribeToMessages(conversationId);

      return stream.map((payload) {
        try {
          final message = MessageModel.fromJson(
            payload.newRecord,
            currentUserId,
          );
          return Right(message);
        } catch (e) {
          return Left(ServerFailure(e.toString()));
        }
      });
    } catch (e) {
      return Stream.value(Left(ServerFailure(e.toString())));
    }
  }

  @override
  Future<void> markAsRead({
    required String conversationId,
    required List<String> messageIds,
  }) async {
    try {
      for (final messageId in messageIds) {
        await supabaseService.client
            .from('messages')
            .update({'status': MessageStatus.read.toString().split('.').last})
            .eq('id', messageId);
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> sendTypingIndicator({
    required String conversationId,
    required String userId,
    required bool isTyping,
  }) async {
    try {
      await supabaseService.client.from('typing_indicators').upsert({
        'conversation_id': conversationId,
        'user_id': userId,
        'is_typing': isTyping,
        'updated_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Stream<Either<Failure, bool>> subscribeToTypingIndicator({
    required String conversationId,
    required String currentUserId,
  }) {
    try {
      final stream = realtimeService.subscribeToTypingIndicator(conversationId);

      return stream.map((payload) {
        try {
          // Ignore own typing events
          if (payload.newRecord['user_id'] == currentUserId) {
            return const Right(false);
          }
          return Right(payload.newRecord['is_typing'] as bool? ?? false);
        } catch (e) {
          return Left(ServerFailure(e.toString()));
        }
      });
    } catch (e) {
      return Stream.value(Left(ServerFailure(e.toString())));
    }
  }

  @override
  Future<ConversationModel> getConversationByOrderId({
    required String orderId,
    required String currentUserId,
  }) async {
    try {
      final response = await supabaseService.client
          .from('conversations')
          .select()
          .eq('order_id', orderId)
          .single();

      return ConversationModel.fromJson(
          response as Map<String, dynamic>, currentUserId);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ConversationModel> createConversation({
    required String orderId,
    required String driverId,
    required String customerId,
    required String currentUserId,
  }) async {
    try {
      final conversationData = {
        'order_id': orderId,
        'driver_id': driverId,
        'customer_id': customerId,
        'unread_count': 0,
        'last_activity': DateTime.now().toIso8601String(),
      };

      final response = await supabaseService.client
          .from('conversations')
          .insert(conversationData)
          .select()
          .single();

      return ConversationModel.fromJson(
          response as Map<String, dynamic>, currentUserId);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> uploadImage({
    required String conversationId,
    required String imagePath,
  }) async {
    try {
      final file = File(imagePath);
      final fileName = 'chat_$conversationId/${DateTime.now().millisecondsSinceEpoch}.jpg';

      await supabaseService.client.storage
          .from('chat_images')
          .upload(fileName, file);

      final url = supabaseService.client.storage
          .from('chat_images')
          .getPublicUrl(fileName);

      return url;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Map<String, String>> uploadFile({
    required String conversationId,
    required String filePath,
  }) async {
    try {
      final file = File(filePath);
      final originalFileName = filePath.split('/').last;
      final fileName = 'chat_$conversationId/${DateTime.now().millisecondsSinceEpoch}_$originalFileName';

      await supabaseService.client.storage
          .from('chat_files')
          .upload(fileName, file);

      final url = supabaseService.client.storage
          .from('chat_files')
          .getPublicUrl(fileName);

      return {
        'url': url,
        'fileName': originalFileName,
      };
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
