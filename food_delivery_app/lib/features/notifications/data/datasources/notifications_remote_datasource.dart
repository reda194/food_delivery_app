import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../core/services/realtime_service.dart';
import '../models/notification_model.dart';

abstract class NotificationsRemoteDataSource {
  Future<List<NotificationModel>> getNotifications({
    required String userId,
    int limit = 50,
    int offset = 0,
  });

  Future<int> getUnreadCount(String userId);
  Future<void> markAsRead(String notificationId);
  Future<void> markAllAsRead(String userId);
  Future<void> deleteNotification(String notificationId);
  Future<void> deleteAllNotifications(String userId);

  Stream<Either<Failure, NotificationModel>> subscribeToNotifications(
      String userId);

  Future<void> saveFcmToken(String userId, String token);
  Future<void> deleteFcmToken(String userId);
}

class NotificationsRemoteDataSourceImpl
    implements NotificationsRemoteDataSource {
  final SupabaseService supabaseService;
  final RealtimeService realtimeService;

  NotificationsRemoteDataSourceImpl({
    required this.supabaseService,
    required this.realtimeService,
  });

  @override
  Future<List<NotificationModel>> getNotifications({
    required String userId,
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final response = await supabaseService.client
          .from('notifications')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      return (response as List)
          .map((json) =>
              NotificationModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<int> getUnreadCount(String userId) async {
    try {
      final response = await supabaseService.client
          .from('notifications')
          .select()
          .eq('user_id', userId)
          .eq('is_read', false);

      return (response as List).length;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    try {
      await supabaseService.client.from('notifications').update({
        'is_read': true,
        'read_at': DateTime.now().toIso8601String(),
      }).eq('id', notificationId);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> markAllAsRead(String userId) async {
    try {
      await supabaseService.client.from('notifications').update({
        'is_read': true,
        'read_at': DateTime.now().toIso8601String(),
      }).eq('user_id', userId).eq('is_read', false);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    try {
      await supabaseService.client
          .from('notifications')
          .delete()
          .eq('id', notificationId);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteAllNotifications(String userId) async {
    try {
      await supabaseService.client
          .from('notifications')
          .delete()
          .eq('user_id', userId);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Stream<Either<Failure, NotificationModel>> subscribeToNotifications(
      String userId) {
    try {
      final stream = realtimeService.subscribeToUserNotifications(userId);

      return stream.map((payload) {
        try {
          final notification = NotificationModel.fromJson(payload.newRecord);
          return Right(notification);
        } catch (e) {
          return Left(ServerFailure(e.toString()));
        }
      });
    } catch (e) {
      return Stream.value(Left(ServerFailure(e.toString())));
    }
  }

  @override
  Future<void> saveFcmToken(String userId, String token) async {
    try {
      await supabaseService.client.from('fcm_tokens').upsert({
        'user_id': userId,
        'token': token,
        'updated_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteFcmToken(String userId) async {
    try {
      await supabaseService.client
          .from('fcm_tokens')
          .delete()
          .eq('user_id', userId);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
