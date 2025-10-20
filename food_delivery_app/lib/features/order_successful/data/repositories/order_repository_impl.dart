import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/logger_service.dart';
import '../../domain/models/order_success_args.dart';
import '../datasources/order_remote_datasource.dart';
import '../models/order_model.dart';

/// Order Repository Interface - Domain layer
abstract class OrderRepository {
  /// Get order by ID
  Future<Either<Failure, OrderSuccessArgs>> getOrderById(String orderId);

  /// Get user's order history
  Future<Either<Failure, List<OrderModel>>> getUserOrders(String userId);

  /// Create a new order
  Future<Either<Failure, OrderSuccessArgs>> createOrder(
      Map<String, dynamic> orderData);

  /// Update order status
  Future<Either<Failure, OrderSuccessArgs>> updateOrderStatus(
      String orderId, String status);
}

/// Order Repository Implementation
class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;
  final LoggerService _logger = LoggerService.instance;

  OrderRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, OrderSuccessArgs>> getOrderById(
      String orderId) async {
    try {
      final order = await remoteDataSource.getOrderById(orderId);
      return Right(order.toOrderSuccessArgs());
    } catch (e) {
      _logger.error('Repository error - getOrderById: $e');
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<OrderModel>>> getUserOrders(
      String userId) async {
    try {
      final orders = await remoteDataSource.getUserOrders(userId);
      return Right(orders);
    } catch (e) {
      _logger.error('Repository error - getUserOrders: $e');
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, OrderSuccessArgs>> createOrder(
      Map<String, dynamic> orderData) async {
    try {
      final order = await remoteDataSource.createOrder(orderData);
      return Right(order.toOrderSuccessArgs());
    } catch (e) {
      _logger.error('Repository error - createOrder: $e');
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, OrderSuccessArgs>> updateOrderStatus(
      String orderId, String status) async {
    try {
      final order = await remoteDataSource.updateOrderStatus(orderId, status);
      return Right(order.toOrderSuccessArgs());
    } catch (e) {
      _logger.error('Repository error - updateOrderStatus: $e');
      return Left(_mapExceptionToFailure(e));
    }
  }

  /// Map exceptions to domain layer failures
  Failure _mapExceptionToFailure(dynamic exception) {
    if (exception is ServerException) {
      return ServerFailure(exception.message);
    }

    if (exception is NetworkException) {
      return NetworkFailure(exception.message);
    }

    if (exception is ValidationException) {
      return ValidationFailure(exception.message);
    }

    if (exception is TimeoutException) {
      return const NetworkFailure('Request timed out. Please try again.');
    }

    if (exception is SocketException) {
      return const NetworkFailure(
          'No internet connection. Please check your network.');
    }

    return ServerFailure('Unexpected error: ${exception.toString()}');
  }
}
