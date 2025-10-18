import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/order_status_entity.dart';
import '../repositories/order_tracking_repository.dart';

/// Use case to get current order status
class GetOrderStatusUseCase implements UseCase<OrderStatusEntity, GetOrderStatusParams> {
  final OrderTrackingRepository repository;

  GetOrderStatusUseCase(this.repository);

  @override
  Future<Either<Failure, OrderStatusEntity>> call(GetOrderStatusParams params) async {
    return await repository.getOrderStatus(params.orderId);
  }
}

class GetOrderStatusParams extends Equatable {
  final String orderId;

  const GetOrderStatusParams({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}
