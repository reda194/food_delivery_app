import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/payment_method_entity.dart';
import '../repositories/checkout_repository.dart';

/// Get Payment Methods Use Case
class GetPaymentMethodsUseCase {
  final CheckoutRepository repository;

  GetPaymentMethodsUseCase(this.repository);

  Future<Either<Failure, List<PaymentMethodEntity>>> call() async {
    return await repository.getPaymentMethods();
  }
}
