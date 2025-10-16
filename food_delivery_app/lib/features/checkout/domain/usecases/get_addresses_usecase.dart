import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/address_entity.dart';
import '../repositories/checkout_repository.dart';

/// Get Addresses Use Case
class GetAddressesUseCase {
  final CheckoutRepository repository;

  GetAddressesUseCase(this.repository);

  Future<Either<Failure, List<AddressEntity>>> call() async {
    return await repository.getAddresses();
  }
}
