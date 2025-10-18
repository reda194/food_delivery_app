import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/usecases/get_messages_usecase.dart';
import '../../domain/usecases/mark_as_read_usecase.dart';
import '../../domain/usecases/send_message_usecase.dart';
import '../../domain/usecases/send_typing_indicator_usecase.dart';
import '../../domain/usecases/subscribe_to_messages_usecase.dart';
import '../../domain/usecases/upload_image_usecase.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;
  final GetMessagesUseCase getMessagesUseCase;
  final SendMessageUseCase sendMessageUseCase;
  final MarkAsReadUseCase markAsReadUseCase;
  final SendTypingIndicatorUseCase sendTypingIndicatorUseCase;
  final SubscribeToMessagesUseCase subscribeToMessagesUseCase;
  final UploadImageUseCase uploadImageUseCase;

  StreamSubscription? _messagesSubscription;
  StreamSubscription? _typingSubscription;
  Timer? _typingTimer;
  String? _currentConversationId;

  ChatBloc({
    required this.chatRepository,
    required this.getMessagesUseCase,
    required this.sendMessageUseCase,
    required this.markAsReadUseCase,
    required this.sendTypingIndicatorUseCase,
    required this.subscribeToMessagesUseCase,
    required this.uploadImageUseCase,
  }) : super(const ChatInitial()) {
    on<LoadConversationEvent>(_onLoadConversation);
    on<SendTextMessageEvent>(_onSendTextMessage);
    on<SendImageMessageEvent>(_onSendImageMessage);
    on<SendFileMessageEvent>(_onSendFileMessage);
    on<MessageReceivedEvent>(_onMessageReceived);
    on<MarkMessagesAsReadEvent>(_onMarkMessagesAsRead);
    on<StartTypingEvent>(_onStartTyping);
    on<StopTypingEvent>(_onStopTyping);
    on<TypingIndicatorReceivedEvent>(_onTypingIndicatorReceived);
    on<LoadMoreMessagesEvent>(_onLoadMoreMessages);
  }

  Future<void> _onLoadConversation(
    LoadConversationEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(const ChatLoading());

    // Get or create conversation
    final conversationResult =
        await chatRepository.getConversationByOrderId(orderId: event.orderId);

    await conversationResult.fold(
      (failure) async {
        emit(ChatError(message: failure.message));
      },
      (conversation) async {
        _currentConversationId = conversation.id;

        // Load messages
        final messagesResult = await getMessagesUseCase(
          GetMessagesParams(conversationId: conversation.id),
        );

        messagesResult.fold(
          (failure) => emit(ChatError(message: failure.message)),
          (messages) {
            emit(ChatLoaded(
              conversation: conversation,
              messages: messages,
              hasMoreMessages: messages.length >= 50,
            ));

            // Subscribe to real-time messages
            _subscribeToMessages(conversation.id);

            // Subscribe to typing indicators
            _subscribeToTypingIndicators(conversation.id);

            // Mark unread messages as read
            final unreadMessages =
                messages.where((m) => !m.isMe && m.status != MessageStatus.read).toList();
            if (unreadMessages.isNotEmpty) {
              add(MarkMessagesAsReadEvent(
                messageIds: unreadMessages.map((m) => m.id).toList(),
              ));
            }
          },
        );
      },
    );
  }

  Future<void> _onSendTextMessage(
    SendTextMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    if (_currentConversationId == null || state is! ChatLoaded) return;

    final currentState = state as ChatLoaded;

    final result = await sendMessageUseCase(
      SendMessageParams(
        conversationId: _currentConversationId!,
        content: event.content,
        type: MessageType.text,
      ),
    );

    result.fold(
      (failure) => emit(ChatError(message: failure.message)),
      (message) {
        // Message will be added via real-time subscription
      },
    );
  }

  Future<void> _onSendImageMessage(
    SendImageMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    if (_currentConversationId == null || state is! ChatLoaded) return;

    // Upload image first
    final uploadResult = await uploadImageUseCase(
      UploadImageParams(
        conversationId: _currentConversationId!,
        imagePath: event.imagePath,
      ),
    );

    await uploadResult.fold(
      (failure) async => emit(ChatError(message: failure.message)),
      (imageUrl) async {
        // Send message with image URL
        final result = await sendMessageUseCase(
          SendMessageParams(
            conversationId: _currentConversationId!,
            content: 'Image',
            type: MessageType.image,
            imageUrl: imageUrl,
          ),
        );

        result.fold(
          (failure) => emit(ChatError(message: failure.message)),
          (message) {
            // Message will be added via real-time subscription
          },
        );
      },
    );
  }

  Future<void> _onSendFileMessage(
    SendFileMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    if (_currentConversationId == null || state is! ChatLoaded) return;

    // Upload file first
    final uploadResult = await chatRepository.uploadFile(
      conversationId: _currentConversationId!,
      filePath: event.filePath,
    );

    await uploadResult.fold(
      (failure) async => emit(ChatError(message: failure.message)),
      (fileData) async {
        // Send message with file URL
        final result = await sendMessageUseCase(
          SendMessageParams(
            conversationId: _currentConversationId!,
            content: fileData['fileName'] ?? 'File',
            type: MessageType.file,
            fileUrl: fileData['url'],
            fileName: fileData['fileName'],
          ),
        );

        result.fold(
          (failure) => emit(ChatError(message: failure.message)),
          (message) {
            // Message will be added via real-time subscription
          },
        );
      },
    );
  }

  void _onMessageReceived(
    MessageReceivedEvent event,
    Emitter<ChatState> emit,
  ) {
    if (state is! ChatLoaded) return;

    final currentState = state as ChatLoaded;
    final updatedMessages = List<MessageEntity>.from(currentState.messages)
      ..add(event.message);

    emit(currentState.copyWith(messages: updatedMessages));

    // Mark as read if not from me
    if (!event.message.isMe) {
      add(MarkMessagesAsReadEvent(messageIds: [event.message.id]));
    }
  }

  Future<void> _onMarkMessagesAsRead(
    MarkMessagesAsReadEvent event,
    Emitter<ChatState> emit,
  ) async {
    if (_currentConversationId == null) return;

    await markAsReadUseCase(
      MarkAsReadParams(
        conversationId: _currentConversationId!,
        messageIds: event.messageIds,
      ),
    );
  }

  Future<void> _onStartTyping(
    StartTypingEvent event,
    Emitter<ChatState> emit,
  ) async {
    if (_currentConversationId == null) return;

    // Send typing indicator
    await sendTypingIndicatorUseCase(
      SendTypingIndicatorParams(
        conversationId: _currentConversationId!,
        isTyping: true,
      ),
    );

    // Cancel existing timer
    _typingTimer?.cancel();

    // Auto-stop typing after 3 seconds
    _typingTimer = Timer(const Duration(seconds: 3), () {
      add(const StopTypingEvent());
    });
  }

  Future<void> _onStopTyping(
    StopTypingEvent event,
    Emitter<ChatState> emit,
  ) async {
    if (_currentConversationId == null) return;

    _typingTimer?.cancel();

    await sendTypingIndicatorUseCase(
      SendTypingIndicatorParams(
        conversationId: _currentConversationId!,
        isTyping: false,
      ),
    );
  }

  void _onTypingIndicatorReceived(
    TypingIndicatorReceivedEvent event,
    Emitter<ChatState> emit,
  ) {
    if (state is! ChatLoaded) return;

    final currentState = state as ChatLoaded;
    emit(currentState.copyWith(isOtherUserTyping: event.isTyping));
  }

  Future<void> _onLoadMoreMessages(
    LoadMoreMessagesEvent event,
    Emitter<ChatState> emit,
  ) async {
    if (state is! ChatLoaded || _currentConversationId == null) return;

    final currentState = state as ChatLoaded;

    if (!currentState.hasMoreMessages || currentState.isLoadingMore) return;

    emit(currentState.copyWith(isLoadingMore: true));

    final oldestMessageId =
        currentState.messages.isNotEmpty ? currentState.messages.first.id : null;

    final result = await getMessagesUseCase(
      GetMessagesParams(
        conversationId: _currentConversationId!,
        beforeMessageId: oldestMessageId,
      ),
    );

    result.fold(
      (failure) => emit(ChatError(message: failure.message)),
      (newMessages) {
        final allMessages = [...newMessages, ...currentState.messages];
        emit(currentState.copyWith(
          messages: allMessages,
          hasMoreMessages: newMessages.length >= 50,
          isLoadingMore: false,
        ));
      },
    );
  }

  void _subscribeToMessages(String conversationId) {
    _messagesSubscription?.cancel();

    final stream = subscribeToMessagesUseCase(
      SubscribeToMessagesParams(conversationId: conversationId),
    );

    _messagesSubscription = stream.listen((result) {
      result.fold(
        (failure) {
          // Handle error silently
        },
        (message) {
          add(MessageReceivedEvent(message: message));
        },
      );
    });
  }

  void _subscribeToTypingIndicators(String conversationId) {
    _typingSubscription?.cancel();

    final stream = chatRepository.subscribeToTypingIndicator(
      conversationId: conversationId,
    );

    _typingSubscription = stream.listen((result) {
      result.fold(
        (failure) {
          // Handle error silently
        },
        (isTyping) {
          add(TypingIndicatorReceivedEvent(isTyping: isTyping));
        },
      );
    });
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    _typingSubscription?.cancel();
    _typingTimer?.cancel();
    return super.close();
  }
}
