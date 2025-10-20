import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/geocoding_service.dart';

/// Validate Address Use Case
/// Validates an address using geocoding service
class ValidateAddressUseCase {
  final GeocodingService geocodingService;

  ValidateAddressUseCase(this.geocodingService);

  Future<Either<Failure, GeocodingResult>> call(String address) async {
    try {
      if (address.trim().isEmpty) {
        return const Left(ValidationFailure('Address cannot be empty'));
      }

      final result = await geocodingService.validateAddress(address);

      if (!result.isValid) {
        return const Left(ValidationFailure('Invalid address'));
      }

      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
