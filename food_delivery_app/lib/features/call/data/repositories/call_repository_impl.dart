import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/call_session_entity.dart';
import '../../domain/repositories/call_repository.dart';
import '../datasources/call_local_datasource.dart';
import '../datasources/call_remote_datasource.dart';
import '../models/call_session_model.dart';

class CallRepositoryImpl implements CallRepository {
  final CallLocalDataSource localDataSource;
  final CallRemoteDataSource remoteDataSource;

  CallRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, void>> saveCallSession(
      CallSessionEntity callSession) async {
    try {
      final callModel = CallSessionModel(
        id: callSession.id,
        orderId: callSession.orderId,
        driverName: callSession.driverName,
        driverPhoneNumber: callSession.driverPhoneNumber,
        driverImageUrl: callSession.driverImageUrl,
        callType: callSession.callType,
        startTime: callSession.startTime,
        endTime: callSession.endTime,
        duration: callSession.duration,
      );

      // Save locally
      await localDataSource.saveCallHistory(callModel);

      // Try to log to server (non-blocking)
      remoteDataSource.logCallSession(callModel);

      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CallSessionEntity>>> getCallHistory() async {
    try {
      final history = await localDataSource.getCallHistory();
      return Right(history);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearCallHistory() async {
    try {
      await localDataSource.clearCallHistory();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
