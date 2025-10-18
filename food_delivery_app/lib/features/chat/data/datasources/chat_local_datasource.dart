import 'package:hive_flutter/hive_flutter.dart';
import '../models/message_model.dart';

abstract class ChatLocalDataSource {
  Future<void> cacheMessages(String conversationId, List<MessageModel> messages);
  Future<List<MessageModel>> getCachedMessages(String conversationId);
  Future<void> clearCache(String conversationId);
  Future<void> cacheMessage(MessageModel message);
  Future<void> updateMessageStatus(String messageId, String status);
}

class ChatLocalDataSourceImpl implements ChatLocalDataSource {
  static const String messagesBoxName = 'chat_messages';

  Box<Map<dynamic, dynamic>>? _messagesBox;

  Future<void> init() async {
    if (!Hive.isBoxOpen(messagesBoxName)) {
      _messagesBox = await Hive.openBox<Map<dynamic, dynamic>>(messagesBoxName);
    } else {
      _messagesBox = Hive.box<Map<dynamic, dynamic>>(messagesBoxName);
    }
  }

  @override
  Future<void> cacheMessages(
      String conversationId, List<MessageModel> messages) async {
    await init();

    final messagesJson = messages.map((msg) => msg.toJson()).toList();
    await _messagesBox?.put(conversationId, {'messages': messagesJson});
  }

  @override
  Future<List<MessageModel>> getCachedMessages(String conversationId) async {
    await init();

    final data = _messagesBox?.get(conversationId);
    if (data == null || data['messages'] == null) {
      return [];
    }

    final messagesList = data['messages'] as List<dynamic>;
    // We need currentUserId for fromJson, so we'll return empty for now
    // In a real app, you'd get currentUserId from auth service
    return messagesList
        .map((json) => MessageModel.fromJson(
              Map<String, dynamic>.from(json as Map),
              '', // currentUserId placeholder
            ))
        .toList();
  }

  @override
  Future<void> clearCache(String conversationId) async {
    await init();
    await _messagesBox?.delete(conversationId);
  }

  @override
  Future<void> cacheMessage(MessageModel message) async {
    await init();

    final existingMessages = await getCachedMessages(message.conversationId);
    existingMessages.add(message);
    await cacheMessages(message.conversationId, existingMessages);
  }

  @override
  Future<void> updateMessageStatus(String messageId, String status) async {
    await init();

    // Find the conversation containing this message
    final allKeys = _messagesBox?.keys.toList() ?? [];

    for (final key in allKeys) {
      final data = _messagesBox?.get(key);
      if (data != null && data['messages'] != null) {
        final messagesList = List<Map<String, dynamic>>.from(
          (data['messages'] as List).map((m) => Map<String, dynamic>.from(m as Map)),
        );

        final messageIndex = messagesList.indexWhere((m) => m['id'] == messageId);
        if (messageIndex != -1) {
          messagesList[messageIndex]['status'] = status;
          await _messagesBox?.put(key, {'messages': messagesList});
          break;
        }
      }
    }
  }
}
