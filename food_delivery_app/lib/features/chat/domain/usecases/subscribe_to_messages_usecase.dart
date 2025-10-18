import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/message_entity.dart';
import '../repositories/chat_repository.dart';

class SubscribeToMessagesUseCase {
  final ChatRepository repository;

  SubscribeToMessagesUseCase(this.repository);

  Stream<Either<Failure, MessageEntity>> call(
      SubscribeToMessagesParams params) {
    return repository.subscribeToMessages(
      conversationId: params.conversationId,
    );
  }
}

class SubscribeToMessagesParams extends Equatable {
  final String conversationId;

  const SubscribeToMessagesParams({required this.conversationId});

  @override
  List<Object?> get props => [conversationId];
}
