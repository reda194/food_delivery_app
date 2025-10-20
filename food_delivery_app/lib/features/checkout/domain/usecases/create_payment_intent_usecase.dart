import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/payment_service.dart';

/// Create Payment Intent Use Case
/// Creates a Stripe payment intent for processing payment
class CreatePaymentIntentUseCase {
  final PaymentService paymentService;

  CreatePaymentIntentUseCase(this.paymentService);

  Future<Either<Failure, String>> call({
    required double amount,
    required String currency,
    String? customerId,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      if (amount <= 0) {
        return const Left(ValidationFailure('Amount must be greater than 0'));
      }

      final paymentIntent = await paymentService.createPaymentIntent(
        amount: amount,
        currency: currency,
        customerId: customerId,
        metadata: metadata,
      );

      final clientSecret = paymentIntent['client_secret'] as String?;
      if (clientSecret == null) {
        return const Left(ServerFailure('Failed to create payment intent'));
      }

      return Right(clientSecret);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
