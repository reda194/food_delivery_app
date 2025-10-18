import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/chat_repository.dart';

class UploadImageUseCase implements UseCase<String, UploadImageParams> {
  final ChatRepository repository;

  UploadImageUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(UploadImageParams params) async {
    return await repository.uploadImage(
      conversationId: params.conversationId,
      imagePath: params.imagePath,
    );
  }
}

class UploadImageParams extends Equatable {
  final String conversationId;
  final String imagePath;

  const UploadImageParams({
    required this.conversationId,
    required this.imagePath,
  });

  @override
  List<Object?> get props => [conversationId, imagePath];
}
