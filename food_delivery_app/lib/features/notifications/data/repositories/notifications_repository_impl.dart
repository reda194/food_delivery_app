import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/fcm_service.dart';
import '../../../../core/services/supabase_service.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../datasources/notifications_local_datasource.dart';
import '../datasources/notifications_remote_datasource.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationsRemoteDataSource remoteDataSource;
  final NotificationsLocalDataSource localDataSource;
  final SupabaseService supabaseService;
  final FcmService fcmService;

  NotificationsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.supabaseService,
    required this.fcmService,
  });

  String get _currentUserId => supabaseService.currentUser?.id ?? '';

  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotifications({
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final notifications = await remoteDataSource.getNotifications(
        userId: _currentUserId,
        limit: limit,
        offset: offset,
      );

      // Cache locally
      await localDataSource.cacheNotifications(notifications);

      return Right(notifications);
    } on ServerException catch (e) {
      // Try to get cached notifications on error
      try {
        final cachedNotifications =
            await localDataSource.getCachedNotifications();
        if (cachedNotifications.isNotEmpty) {
          return Right(cachedNotifications);
        }
      } catch (_) {}

      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getUnreadCount() async {
    try {
      final count = await remoteDataSource.getUnreadCount(_currentUserId);
      return Right(count);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead(String notificationId) async {
    try {
      await remoteDataSource.markAsRead(notificationId);
      await localDataSource.markAsRead(notificationId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAllAsRead() async {
    try {
      await remoteDataSource.markAllAsRead(_currentUserId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteNotification(String notificationId) async {
    try {
      await remoteDataSource.deleteNotification(notificationId);
      await localDataSource.deleteNotification(notificationId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAllNotifications() async {
    try {
      await remoteDataSource.deleteAllNotifications(_currentUserId);
      await localDataSource.clearCache();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, NotificationEntity>> subscribeToNotifications() {
    return remoteDataSource.subscribeToNotifications(_currentUserId);
  }

  @override
  Future<Either<Failure, void>> saveFcmToken(String token) async {
    try {
      await remoteDataSource.saveFcmToken(_currentUserId, token);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteFcmToken() async {
    try {
      await remoteDataSource.deleteFcmToken(_currentUserId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> requestPermissions() async {
    try {
      final isGranted = await fcmService.requestPermissions();
      return Right(isGranted);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> areNotificationsEnabled() async {
    try {
      final isEnabled = await fcmService.areNotificationsEnabled();
      return Right(isEnabled);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
