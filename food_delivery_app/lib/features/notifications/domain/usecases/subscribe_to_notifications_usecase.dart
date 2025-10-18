import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/notification_entity.dart';
import '../repositories/notifications_repository.dart';

class SubscribeToNotificationsUseCase {
  final NotificationsRepository repository;

  SubscribeToNotificationsUseCase(this.repository);

  Stream<Either<Failure, NotificationEntity>> call() {
    return repository.subscribeToNotifications();
  }
}
