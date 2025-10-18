import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/delete_notification_usecase.dart';
import '../../domain/usecases/get_notifications_usecase.dart';
import '../../domain/usecases/get_unread_count_usecase.dart';
import '../../domain/usecases/mark_as_read_usecase.dart';
import '../../domain/usecases/subscribe_to_notifications_usecase.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../../../notifications/data/models/notification_model.dart';
import 'notifications_event.dart';
import 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final GetNotificationsUseCase getNotificationsUseCase;
  final GetUnreadCountUseCase getUnreadCountUseCase;
  final MarkAsReadUseCase markAsReadUseCase;
  final DeleteNotificationUseCase deleteNotificationUseCase;
  final SubscribeToNotificationsUseCase subscribeToNotificationsUseCase;
  final NotificationsRepository notificationsRepository;

  static const int _pageSize = 50;
  StreamSubscription? _notificationSubscription;

  NotificationsBloc({
    required this.getNotificationsUseCase,
    required this.getUnreadCountUseCase,
    required this.markAsReadUseCase,
    required this.deleteNotificationUseCase,
    required this.subscribeToNotificationsUseCase,
    required this.notificationsRepository,
  }) : super(const NotificationsInitial()) {
    on<LoadNotificationsEvent>(_onLoadNotifications);
    on<LoadMoreNotificationsEvent>(_onLoadMoreNotifications);
    on<RefreshNotificationsEvent>(_onRefreshNotifications);
    on<NotificationReceivedEvent>(_onNotificationReceived);
    on<MarkAsReadEvent>(_onMarkAsRead);
    on<MarkAllAsReadEvent>(_onMarkAllAsRead);
    on<DeleteNotificationEvent>(_onDeleteNotification);
    on<DeleteAllNotificationsEvent>(_onDeleteAllNotifications);
    on<RequestPermissionsEvent>(_onRequestPermissions);
    on<SaveFcmTokenEvent>(_onSaveFcmToken);
  }

  Future<void> _onLoadNotifications(
    LoadNotificationsEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(const NotificationsLoading());

    // Check permissions
    final permissionsResult =
        await notificationsRepository.areNotificationsEnabled();
    final permissionsGranted = permissionsResult.getOrElse(() => false);

    // Get notifications
    final notificationsResult = await getNotificationsUseCase(
      const GetNotificationsParams(limit: _pageSize),
    );

    // Get unread count
    final unreadResult = await getUnreadCountUseCase(const NoParams());

    await notificationsResult.fold(
      (failure) async {
        emit(NotificationsError(message: failure.message));
      },
      (notifications) async {
        final unreadCount = unreadResult.getOrElse(() => 0);

        emit(NotificationsLoaded(
          notifications: notifications,
          unreadCount: unreadCount,
          hasMore: notifications.length >= _pageSize,
          permissionsGranted: permissionsGranted,
        ));

        // Subscribe to real-time notifications
        _subscribeToNotifications();
      },
    );
  }

  Future<void> _onLoadMoreNotifications(
    LoadMoreNotificationsEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    if (state is! NotificationsLoaded) return;

    final currentState = state as NotificationsLoaded;

    if (!currentState.hasMore || currentState.isLoadingMore) return;

    emit(currentState.copyWith(isLoadingMore: true));

    final result = await getNotificationsUseCase(
      GetNotificationsParams(
        limit: _pageSize,
        offset: currentState.notifications.length,
      ),
    );

    result.fold(
      (failure) => emit(NotificationsError(message: failure.message)),
      (newNotifications) {
        final allNotifications = [
          ...currentState.notifications,
          ...newNotifications
        ];
        emit(currentState.copyWith(
          notifications: allNotifications,
          hasMore: newNotifications.length >= _pageSize,
          isLoadingMore: false,
        ));
      },
    );
  }

  Future<void> _onRefreshNotifications(
    RefreshNotificationsEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    if (state is! NotificationsLoaded) return;

    final notificationsResult = await getNotificationsUseCase(
      const GetNotificationsParams(limit: _pageSize),
    );

    final unreadResult = await getUnreadCountUseCase(const NoParams());

    notificationsResult.fold(
      (failure) => emit(NotificationsError(message: failure.message)),
      (notifications) {
        final currentState = state as NotificationsLoaded;
        final unreadCount = unreadResult.getOrElse(() => 0);

        emit(currentState.copyWith(
          notifications: notifications,
          unreadCount: unreadCount,
          hasMore: notifications.length >= _pageSize,
        ));
      },
    );
  }

  void _onNotificationReceived(
    NotificationReceivedEvent event,
    Emitter<NotificationsState> emit,
  ) {
    if (state is! NotificationsLoaded) return;

    final currentState = state as NotificationsLoaded;

    // Create notification from FCM data
    final notification =
        NotificationModel.fromFcmMessage(event.notificationData);

    // Add to top of list
    final updatedNotifications = [
      notification,
      ...currentState.notifications
    ];

    emit(currentState.copyWith(
      notifications: updatedNotifications,
      unreadCount: currentState.unreadCount + 1,
    ));
  }

  Future<void> _onMarkAsRead(
    MarkAsReadEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    if (state is! NotificationsLoaded) return;

    final currentState = state as NotificationsLoaded;

    final result =
        await markAsReadUseCase(MarkAsReadParams.single(event.notificationId));

    result.fold(
      (failure) {
        // Silently fail or show snackbar
      },
      (_) {
        // Update notification in list
        final updatedNotifications = currentState.notifications.map((n) {
          if (n.id == event.notificationId && !n.isRead) {
            return NotificationModel(
              id: n.id,
              userId: n.userId,
              title: n.title,
              body: n.body,
              type: n.type,
              priority: n.priority,
              data: n.data,
              imageUrl: n.imageUrl,
              actionUrl: n.actionUrl,
              isRead: true,
              createdAt: n.createdAt,
              readAt: DateTime.now(),
            );
          }
          return n;
        }).toList();

        emit(currentState.copyWith(
          notifications: updatedNotifications,
          unreadCount: (currentState.unreadCount - 1).clamp(0, double.infinity).toInt(),
        ));
      },
    );
  }

  Future<void> _onMarkAllAsRead(
    MarkAllAsReadEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    if (state is! NotificationsLoaded) return;

    final currentState = state as NotificationsLoaded;

    final result = await markAsReadUseCase(const MarkAsReadParams.all());

    result.fold(
      (failure) => emit(NotificationsError(message: failure.message)),
      (_) {
        // Mark all notifications as read
        final updatedNotifications = currentState.notifications.map((n) {
          return NotificationModel(
            id: n.id,
            userId: n.userId,
            title: n.title,
            body: n.body,
            type: n.type,
            priority: n.priority,
            data: n.data,
            imageUrl: n.imageUrl,
            actionUrl: n.actionUrl,
            isRead: true,
            createdAt: n.createdAt,
            readAt: n.readAt ?? DateTime.now(),
          );
        }).toList();

        emit(currentState.copyWith(
          notifications: updatedNotifications,
          unreadCount: 0,
        ));
      },
    );
  }

  Future<void> _onDeleteNotification(
    DeleteNotificationEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    if (state is! NotificationsLoaded) return;

    final currentState = state as NotificationsLoaded;

    final result = await deleteNotificationUseCase(
        DeleteNotificationParams.single(event.notificationId));

    result.fold(
      (failure) => emit(NotificationsError(message: failure.message)),
      (_) {
        final updatedNotifications = currentState.notifications
            .where((n) => n.id != event.notificationId)
            .toList();

        final wasUnread = currentState.notifications
            .firstWhere((n) => n.id == event.notificationId)
            .isRead == false;

        emit(currentState.copyWith(
          notifications: updatedNotifications,
          unreadCount: wasUnread
              ? (currentState.unreadCount - 1).clamp(0, double.infinity).toInt()
              : currentState.unreadCount,
        ));
      },
    );
  }

  Future<void> _onDeleteAllNotifications(
    DeleteAllNotificationsEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    if (state is! NotificationsLoaded) return;

    final result =
        await deleteNotificationUseCase(const DeleteNotificationParams.all());

    result.fold(
      (failure) => emit(NotificationsError(message: failure.message)),
      (_) {
        final currentState = state as NotificationsLoaded;
        emit(currentState.copyWith(
          notifications: [],
          unreadCount: 0,
        ));
      },
    );
  }

  Future<void> _onRequestPermissions(
    RequestPermissionsEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    final result = await notificationsRepository.requestPermissions();

    result.fold(
      (failure) {
        // Handle permission denial
      },
      (granted) {
        if (state is NotificationsLoaded) {
          final currentState = state as NotificationsLoaded;
          emit(currentState.copyWith(permissionsGranted: granted));
        }
      },
    );
  }

  Future<void> _onSaveFcmToken(
    SaveFcmTokenEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    await notificationsRepository.saveFcmToken(event.token);
  }

  void _subscribeToNotifications() {
    _notificationSubscription?.cancel();

    final stream = subscribeToNotificationsUseCase();

    _notificationSubscription = stream.listen((result) {
      result.fold(
        (failure) {
          // Handle error silently
        },
        (notification) {
          // This will be handled by FCM real-time updates
        },
      );
    });
  }

  @override
  Future<void> close() {
    _notificationSubscription?.cancel();
    return super.close();
  }
}
