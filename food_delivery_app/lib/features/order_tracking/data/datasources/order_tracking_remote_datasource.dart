import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/database_service.dart';
import '../../../../core/services/realtime_service.dart';
import '../models/order_status_model.dart';

/// Remote data source for order tracking
abstract class OrderTrackingRemoteDataSource {
  /// Get current order status
  Future<OrderStatusModel> getOrderStatus(String orderId);

  /// Subscribe to real-time order updates
  Stream<OrderStatusModel> subscribeToOrderUpdates(String orderId);

  /// Subscribe to driver location updates
  Stream<LatLngModel> subscribeToDriverLocation(String driverId);

  /// Cancel order
  Future<void> cancelOrder(String orderId);

  /// Update driver location (for driver app)
  Future<void> updateDriverLocation(String orderId, double lat, double lng);
}

class OrderTrackingRemoteDataSourceImpl implements OrderTrackingRemoteDataSource {
  final DatabaseService databaseService;
  final RealtimeService realtimeService;

  OrderTrackingRemoteDataSourceImpl({
    required this.databaseService,
    required this.realtimeService,
  });

  @override
  Future<OrderStatusModel> getOrderStatus(String orderId) async {
    try {
      final result = await databaseService.select(
        AppConstants.ordersTable,
        where: 'id=eq.$orderId',
      );

      if (result.isEmpty) {
        throw Exception('Order not found');
      }

      final orderData = result.first;

      // Fetch driver details if assigned
      Map<String, dynamic>? driverData;
      if (orderData['driver_id'] != null) {
        final driverResult = await databaseService.select(
          'drivers',
          where: 'id=eq.${orderData['driver_id']}',
        );

        if (driverResult.isNotEmpty) {
          driverData = driverResult.first;
        }
      }

      // Combine order and driver data
      final combinedData = {
        ...orderData,
        if (driverData != null) ...{
          'driver_name': driverData['name'],
          'driver_phone': driverData['phone'],
          'driver_image': driverData['profile_image'],
          'driver_rating': driverData['rating'],
        },
      };

      return OrderStatusModel.fromJson(combinedData);
    } catch (e) {
      throw Exception('Failed to get order status: $e');
    }
  }

  @override
  Stream<OrderStatusModel> subscribeToOrderUpdates(String orderId) {
    final controller = StreamController<OrderStatusModel>();

    try {
      // Subscribe to real-time changes on orders table
      final orderStream = realtimeService.subscribeToOrderTracking(orderId);

      orderStream.listen(
        (payload) {
          try {
            final orderData = payload.newRecord;
            final model = OrderStatusModel.fromJson(orderData);
            controller.add(model);
          } catch (e) {
            controller.addError(Exception('Failed to parse order update: $e'));
          }
        },
        onError: (error) {
          controller.addError(error);
        },
        onDone: () {
          controller.close();
        },
      );
    } catch (e) {
      controller.addError(Exception('Failed to subscribe to order updates: $e'));
    }

    return controller.stream;
  }

  @override
  Stream<LatLngModel> subscribeToDriverLocation(String driverId) {
    final controller = StreamController<LatLngModel>();

    try {
      // Subscribe to driver location updates
      final locationStream = realtimeService.subscribeToTable(
        table: 'driver_locations',
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'driver_id',
          value: driverId,
        ),
        channelId: 'driver_location_$driverId',
      );

      locationStream.listen(
        (payload) {
          try {
            final locationData = payload.newRecord;
            final location = LatLngModel(
              latitude: (locationData['latitude'] as num).toDouble(),
              longitude: (locationData['longitude'] as num).toDouble(),
            );
            controller.add(location);
          } catch (e) {
            controller.addError(Exception('Failed to parse location: $e'));
          }
        },
        onError: (error) {
          controller.addError(error);
        },
        onDone: () {
          controller.close();
        },
      );
    } catch (e) {
      controller.addError(Exception('Failed to subscribe to driver location: $e'));
    }

    return controller.stream;
  }

  @override
  Future<void> cancelOrder(String orderId) async {
    try {
      await databaseService.update(
        AppConstants.ordersTable,
        {'status': 'cancelled', 'updated_at': DateTime.now().toIso8601String()},
        'id',
        orderId,
      );
    } catch (e) {
      throw Exception('Failed to cancel order: $e');
    }
  }

  @override
  Future<void> updateDriverLocation(String orderId, double lat, double lng) async {
    try {
      await databaseService.update(
        AppConstants.ordersTable,
        {
          'current_location': {'latitude': lat, 'longitude': lng},
          'updated_at': DateTime.now().toIso8601String(),
        },
        'id',
        orderId,
      );
    } catch (e) {
      throw Exception('Failed to update driver location: $e');
    }
  }
}
