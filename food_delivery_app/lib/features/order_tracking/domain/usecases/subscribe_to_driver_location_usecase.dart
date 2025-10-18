import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/order_status_entity.dart';
import '../repositories/order_tracking_repository.dart';

/// Use case to subscribe to driver location updates
class SubscribeToDriverLocationUseCase {
  final OrderTrackingRepository repository;

  SubscribeToDriverLocationUseCase(this.repository);

  Stream<Either<Failure, DriverLocation>> call(SubscribeToDriverParams params) {
    return repository.subscribeToDriverLocation(params.driverId);
  }
}

class SubscribeToDriverParams extends Equatable {
  final String driverId;

  const SubscribeToDriverParams({required this.driverId});

  @override
  List<Object?> get props => [driverId];
}
