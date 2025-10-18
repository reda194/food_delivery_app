import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/chat_repository.dart';

class SendTypingIndicatorUseCase implements UseCase<void, SendTypingIndicatorParams> {
  final ChatRepository repository;

  SendTypingIndicatorUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SendTypingIndicatorParams params) async {
    return await repository.sendTypingIndicator(
      conversationId: params.conversationId,
      isTyping: params.isTyping,
    );
  }
}

class SendTypingIndicatorParams extends Equatable {
  final String conversationId;
  final bool isTyping;

  const SendTypingIndicatorParams({
    required this.conversationId,
    required this.isTyping,
  });

  @override
  List<Object?> get props => [conversationId, isTyping];
}
