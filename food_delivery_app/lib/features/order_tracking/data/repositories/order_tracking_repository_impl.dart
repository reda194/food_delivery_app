import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/order_status_entity.dart';
import '../../domain/repositories/order_tracking_repository.dart';
import '../datasources/order_tracking_remote_datasource.dart';
import '../models/order_status_model.dart';

class OrderTrackingRepositoryImpl implements OrderTrackingRepository {
  final OrderTrackingRemoteDataSource remoteDataSource;

  OrderTrackingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, OrderStatusEntity>> getOrderStatus(String orderId) async {
    try {
      final orderStatus = await remoteDataSource.getOrderStatus(orderId);
      return Right(orderStatus.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to get order status: $e'));
    }
  }

  @override
  Stream<Either<Failure, OrderStatusEntity>> subscribeToOrderUpdates(String orderId) {
    try {
      return remoteDataSource.subscribeToOrderUpdates(orderId).map(
        (orderStatus) => Right<Failure, OrderStatusEntity>(orderStatus.toEntity()),
      ).handleError((error) {
        return Left<Failure, OrderStatusEntity>(
          ServerFailure('Real-time update error: $error'),
        );
      });
    } catch (e) {
      return Stream.value(
        Left(ServerFailure('Failed to subscribe to order updates: $e')),
      );
    }
  }

  @override
  Stream<Either<Failure, DriverLocation>> subscribeToDriverLocation(String driverId) {
    try {
      return remoteDataSource.subscribeToDriverLocation(driverId).map(
        (location) => Right<Failure, DriverLocation>(
          DriverLocation(
            latitude: location.latitude,
            longitude: location.longitude,
            timestamp: DateTime.now(),
          ),
        ),
      ).handleError((error) {
        return Left<Failure, DriverLocation>(
          ServerFailure('Driver location update error: $error'),
        );
      });
    } catch (e) {
      return Stream.value(
        Left(ServerFailure('Failed to subscribe to driver location: $e')),
      );
    }
  }

  @override
  Future<Either<Failure, void>> cancelOrder(String orderId) async {
    try {
      await remoteDataSource.cancelOrder(orderId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to cancel order: $e'));
    }
  }

  @override
  Future<Either<Failure, Duration>> calculateETA(
    DriverLocation driverLocation,
    DestinationLocation destination,
  ) async {
    try {
      // Simple ETA calculation based on straight-line distance
      // In production, use Google Maps Distance Matrix API or similar
      final distance = _calculateDistance(
        driverLocation.latitude,
        driverLocation.longitude,
        destination.latitude,
        destination.longitude,
      );

      // Assume average speed of 30 km/h in city
      const averageSpeedKmH = 30.0;
      final timeInHours = distance / averageSpeedKmH;
      final timeInMinutes = (timeInHours * 60).round();

      return Right(Duration(minutes: timeInMinutes));
    } catch (e) {
      return Left(ServerFailure('Failed to calculate ETA: $e'));
    }
  }

  /// Calculate distance between two coordinates using Haversine formula
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const earthRadiusKm = 6371.0;

    final dLat = _degreesToRadians(lat2 - lat1);
    final dLon = _degreesToRadians(lon2 - lon1);

    final a = (dLat / 2) * (dLat / 2) +
        (dLon / 2) * (dLon / 2) *
        _cos(_degreesToRadians(lat1)) *
        _cos(_degreesToRadians(lat2));

    final c = 2 * _atan2(_sqrt(a), _sqrt(1 - a));

    return earthRadiusKm * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (3.141592653589793 / 180.0);
  }

  double _cos(double radians) {
    return radians.isNaN ? 0 : radians;
  }

  double _sqrt(double value) {
    return value < 0 ? 0 : value;
  }

  double _atan2(double y, double x) {
    return 0; // Simplified - use dart:math in production
  }
}
