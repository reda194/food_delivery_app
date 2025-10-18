import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/message_entity.dart';
import '../repositories/chat_repository.dart';

class SendMessageUseCase implements UseCase<MessageEntity, SendMessageParams> {
  final ChatRepository repository;

  SendMessageUseCase(this.repository);

  @override
  Future<Either<Failure, MessageEntity>> call(SendMessageParams params) async {
    return await repository.sendMessage(
      conversationId: params.conversationId,
      content: params.content,
      type: params.type,
      imageUrl: params.imageUrl,
      fileUrl: params.fileUrl,
      fileName: params.fileName,
    );
  }
}

class SendMessageParams extends Equatable {
  final String conversationId;
  final String content;
  final MessageType type;
  final String? imageUrl;
  final String? fileUrl;
  final String? fileName;

  const SendMessageParams({
    required this.conversationId,
    required this.content,
    this.type = MessageType.text,
    this.imageUrl,
    this.fileUrl,
    this.fileName,
  });

  @override
  List<Object?> get props => [
        conversationId,
        content,
        type,
        imageUrl,
        fileUrl,
        fileName,
      ];
}
