import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../errors/failures.dart';

/// Base class for all use cases
/// Type T is the return type
/// Type Params is the parameters type
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// No parameters class for use cases that don't need parameters
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}
