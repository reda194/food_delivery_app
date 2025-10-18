import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/order_status_entity.dart';
import '../repositories/order_tracking_repository.dart';

/// Use case to subscribe to real-time order updates
class SubscribeToOrderUpdatesUseCase {
  final OrderTrackingRepository repository;

  SubscribeToOrderUpdatesUseCase(this.repository);

  Stream<Either<Failure, OrderStatusEntity>> call(SubscribeToOrderParams params) {
    return repository.subscribeToOrderUpdates(params.orderId);
  }
}

class SubscribeToOrderParams extends Equatable {
  final String orderId;

  const SubscribeToOrderParams({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}
