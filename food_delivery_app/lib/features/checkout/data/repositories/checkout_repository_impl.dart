import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/address_entity.dart';
import '../../domain/entities/payment_method_entity.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/checkout_repository.dart';
import '../datasources/checkout_remote_datasource.dart';
import '../models/address_model.dart';
import '../models/payment_method_model.dart';

/// Checkout Repository Implementation
class CheckoutRepositoryImpl implements CheckoutRepository {
  final CheckoutRemoteDataSource remoteDataSource;

  CheckoutRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<AddressEntity>>> getAddresses() async {
    try {
      final result = await remoteDataSource.getAddresses();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AddressEntity>> addAddress(
    AddressEntity address,
  ) async {
    try {
      final model = AddressModel.fromEntity(address);
      final result = await remoteDataSource.addAddress(model);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AddressEntity>> updateAddress(
    AddressEntity address,
  ) async {
    try {
      final model = AddressModel.fromEntity(address);
      final result = await remoteDataSource.updateAddress(model);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAddress(String addressId) async {
    try {
      await remoteDataSource.deleteAddress(addressId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> setDefaultAddress(String addressId) async {
    try {
      await remoteDataSource.setDefaultAddress(addressId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PaymentMethodEntity>>> getPaymentMethods() async {
    try {
      final result = await remoteDataSource.getPaymentMethods();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PaymentMethodEntity>> addPaymentMethod(
    PaymentMethodEntity paymentMethod,
  ) async {
    try {
      final model = PaymentMethodModel.fromEntity(paymentMethod);
      final result = await remoteDataSource.addPaymentMethod(model);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deletePaymentMethod(
    String paymentMethodId,
  ) async {
    try {
      await remoteDataSource.deletePaymentMethod(paymentMethodId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, double>> calculateDeliveryFee({
    required String restaurantId,
    required String addressId,
  }) async {
    try {
      final result = await remoteDataSource.calculateDeliveryFee(
        restaurantId: restaurantId,
        addressId: addressId,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> placeOrder({
    required String restaurantId,
    required List<dynamic> items,
    required String addressId,
    required String paymentMethodId,
    String? promoCode,
    String? specialInstructions,
  }) async {
    try {
      final result = await remoteDataSource.placeOrder(
        restaurantId: restaurantId,
        items: items,
        addressId: addressId,
        paymentMethodId: paymentMethodId,
        promoCode: promoCode,
        specialInstructions: specialInstructions,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
