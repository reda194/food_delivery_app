import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/message_entity.dart';
import '../repositories/chat_repository.dart';

class GetMessagesUseCase implements UseCase<List<MessageEntity>, GetMessagesParams> {
  final ChatRepository repository;

  GetMessagesUseCase(this.repository);

  @override
  Future<Either<Failure, List<MessageEntity>>> call(
      GetMessagesParams params) async {
    return await repository.getMessages(
      conversationId: params.conversationId,
      limit: params.limit,
      beforeMessageId: params.beforeMessageId,
    );
  }
}

class GetMessagesParams extends Equatable {
  final String conversationId;
  final int limit;
  final String? beforeMessageId;

  const GetMessagesParams({
    required this.conversationId,
    this.limit = 50,
    this.beforeMessageId,
  });

  @override
  List<Object?> get props => [conversationId, limit, beforeMessageId];
}
