import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/supabase_service.dart';
import '../../domain/entities/conversation_entity.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_local_datasource.dart';
import '../datasources/chat_remote_datasource.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;
  final ChatLocalDataSource localDataSource;
  final SupabaseService supabaseService;

  ChatRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.supabaseService,
  });

  String get _currentUserId => supabaseService.currentUser?.id ?? '';

  @override
  Future<Either<Failure, MessageEntity>> sendMessage({
    required String conversationId,
    required String content,
    required MessageType type,
    String? imageUrl,
    String? fileUrl,
    String? fileName,
  }) async {
    try {
      final currentUser = supabaseService.currentUser;
      if (currentUser == null) {
        return Left(ServerFailure('User not authenticated'));
      }

      final message = await remoteDataSource.sendMessage(
        conversationId: conversationId,
        senderId: currentUser.id,
        senderName: currentUser.userMetadata?['display_name'] as String? ?? '',
        senderImageUrl: currentUser.userMetadata?['avatar_url'] as String?,
        content: content,
        type: type,
        imageUrl: imageUrl,
        fileUrl: fileUrl,
        fileName: fileName,
      );

      // Cache locally
      await localDataSource.cacheMessage(message);

      return Right(message);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MessageEntity>>> getMessages({
    required String conversationId,
    int limit = 50,
    String? beforeMessageId,
  }) async {
    try {
      final messages = await remoteDataSource.getMessages(
        conversationId: conversationId,
        currentUserId: _currentUserId,
        limit: limit,
        beforeMessageId: beforeMessageId,
      );

      // Cache locally
      await localDataSource.cacheMessages(conversationId, messages);

      return Right(messages);
    } on ServerException catch (e) {
      // Try to get cached messages on error
      try {
        final cachedMessages =
            await localDataSource.getCachedMessages(conversationId);
        if (cachedMessages.isNotEmpty) {
          return Right(cachedMessages);
        }
      } catch (_) {}

      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, MessageEntity>> subscribeToMessages({
    required String conversationId,
  }) {
    return remoteDataSource.subscribeToMessages(
      conversationId: conversationId,
      currentUserId: _currentUserId,
    );
  }

  @override
  Future<Either<Failure, void>> markAsRead({
    required String conversationId,
    required List<String> messageIds,
  }) async {
    try {
      await remoteDataSource.markAsRead(
        conversationId: conversationId,
        messageIds: messageIds,
      );

      // Update local cache
      for (final messageId in messageIds) {
        await localDataSource.updateMessageStatus(
          messageId,
          MessageStatus.read.toString().split('.').last,
        );
      }

      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendTypingIndicator({
    required String conversationId,
    required bool isTyping,
  }) async {
    try {
      await remoteDataSource.sendTypingIndicator(
        conversationId: conversationId,
        userId: _currentUserId,
        isTyping: isTyping,
      );

      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, bool>> subscribeToTypingIndicator({
    required String conversationId,
  }) {
    return remoteDataSource.subscribeToTypingIndicator(
      conversationId: conversationId,
      currentUserId: _currentUserId,
    );
  }

  @override
  Future<Either<Failure, ConversationEntity>> getConversationByOrderId({
    required String orderId,
  }) async {
    try {
      final conversation = await remoteDataSource.getConversationByOrderId(
        orderId: orderId,
        currentUserId: _currentUserId,
      );

      return Right(conversation);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ConversationEntity>> createConversation({
    required String orderId,
    required String driverId,
    required String customerId,
  }) async {
    try {
      final conversation = await remoteDataSource.createConversation(
        orderId: orderId,
        driverId: driverId,
        customerId: customerId,
        currentUserId: _currentUserId,
      );

      return Right(conversation);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadImage({
    required String conversationId,
    required String imagePath,
  }) async {
    try {
      final imageUrl = await remoteDataSource.uploadImage(
        conversationId: conversationId,
        imagePath: imagePath,
      );

      return Right(imageUrl);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, String>>> uploadFile({
    required String conversationId,
    required String filePath,
  }) async {
    try {
      final fileData = await remoteDataSource.uploadFile(
        conversationId: conversationId,
        filePath: filePath,
      );

      return Right(fileData);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
