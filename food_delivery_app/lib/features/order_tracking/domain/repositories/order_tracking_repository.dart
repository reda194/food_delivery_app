import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/order_status_entity.dart';

/// Repository interface for order tracking operations
abstract class OrderTrackingRepository {
  /// Get current order status
  Future<Either<Failure, OrderStatusEntity>> getOrderStatus(String orderId);

  /// Subscribe to real-time order status updates
  Stream<Either<Failure, OrderStatusEntity>> subscribeToOrderUpdates(
    String orderId,
  );

  /// Subscribe to driver location updates
  Stream<Either<Failure, DriverLocation>> subscribeToDriverLocation(
    String driverId,
  );

  /// Cancel an order
  Future<Either<Failure, void>> cancelOrder(String orderId);

  /// Calculate estimated time of arrival
  Future<Either<Failure, Duration>> calculateETA(
    DriverLocation driverLocation,
    DestinationLocation destination,
  );
}
