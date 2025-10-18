import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/notifications_repository.dart';

class DeleteNotificationUseCase implements UseCase<void, DeleteNotificationParams> {
  final NotificationsRepository repository;

  DeleteNotificationUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteNotificationParams params) async {
    if (params.deleteAll) {
      return await repository.deleteAllNotifications();
    } else if (params.notificationId != null) {
      return await repository.deleteNotification(params.notificationId!);
    } else {
      return Left(CacheFailure('Invalid parameters'));
    }
  }
}

class DeleteNotificationParams extends Equatable {
  final String? notificationId;
  final bool deleteAll;

  const DeleteNotificationParams({
    this.notificationId,
    this.deleteAll = false,
  });

  const DeleteNotificationParams.single(String id)
      : notificationId = id,
        deleteAll = false;

  const DeleteNotificationParams.all()
      : notificationId = null,
        deleteAll = true;

  @override
  List<Object?> get props => [notificationId, deleteAll];
}
