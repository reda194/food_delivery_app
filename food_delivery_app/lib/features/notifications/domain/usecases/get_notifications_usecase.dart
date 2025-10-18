import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/notification_entity.dart';
import '../repositories/notifications_repository.dart';

class GetNotificationsUseCase
    implements UseCase<List<NotificationEntity>, GetNotificationsParams> {
  final NotificationsRepository repository;

  GetNotificationsUseCase(this.repository);

  @override
  Future<Either<Failure, List<NotificationEntity>>> call(
      GetNotificationsParams params) async {
    return await repository.getNotifications(
      limit: params.limit,
      offset: params.offset,
    );
  }
}

class GetNotificationsParams extends Equatable {
  final int limit;
  final int offset;

  const GetNotificationsParams({
    this.limit = 50,
    this.offset = 0,
  });

  @override
  List<Object?> get props => [limit, offset];
}
