import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/order_status_entity.dart';
import '../repositories/order_tracking_repository.dart';

/// Use case to calculate ETA
class CalculateETAUseCase implements UseCase<Duration, CalculateETAParams> {
  final OrderTrackingRepository repository;

  CalculateETAUseCase(this.repository);

  @override
  Future<Either<Failure, Duration>> call(CalculateETAParams params) async {
    return await repository.calculateETA(
      params.driverLocation,
      params.destination,
    );
  }
}

class CalculateETAParams extends Equatable {
  final DriverLocation driverLocation;
  final DestinationLocation destination;

  const CalculateETAParams({
    required this.driverLocation,
    required this.destination,
  });

  @override
  List<Object?> get props => [driverLocation, destination];
}
