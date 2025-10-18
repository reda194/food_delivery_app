import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/notifications_repository.dart';

class MarkAsReadUseCase implements UseCase<void, MarkAsReadParams> {
  final NotificationsRepository repository;

  MarkAsReadUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(MarkAsReadParams params) async {
    if (params.markAll) {
      return await repository.markAllAsRead();
    } else if (params.notificationId != null) {
      return await repository.markAsRead(params.notificationId!);
    } else {
      return Left(CacheFailure('Invalid parameters'));
    }
  }
}

class MarkAsReadParams extends Equatable {
  final String? notificationId;
  final bool markAll;

  const MarkAsReadParams({
    this.notificationId,
    this.markAll = false,
  });

  const MarkAsReadParams.single(String id)
      : notificationId = id,
        markAll = false;

  const MarkAsReadParams.all()
      : notificationId = null,
        markAll = true;

  @override
  List<Object?> get props => [notificationId, markAll];
}
