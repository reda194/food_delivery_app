import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/entities/message_entity.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';

/// Chat Screen - Enhanced with real-time messaging
/// Shows conversation with delivery driver
class ChatScreen extends StatefulWidget {
  final String orderId;
  final String? driverName;
  final String? driverImage;

  const ChatScreen({
    super.key,
    required this.orderId,
    this.driverName,
    this.driverImage,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _imagePicker = ImagePicker();

  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    // Load conversation
    context.read<ChatBloc>().add(LoadConversationEvent(orderId: widget.orderId));

    // Set up typing detection
    _messageController.addListener(_onTextChanged);

    // Set up scroll listener for pagination
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    if (_messageController.text.isNotEmpty && !_isTyping) {
      setState(() => _isTyping = true);
      context.read<ChatBloc>().add(const StartTypingEvent());
    } else if (_messageController.text.isEmpty && _isTyping) {
      setState(() => _isTyping = false);
      context.read<ChatBloc>().add(const StopTypingEvent());
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels == 0) {
      // Scrolled to top - load more messages
      context.read<ChatBloc>().add(const LoadMoreMessagesEvent());
    }
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    context.read<ChatBloc>().add(SendTextMessageEvent(content: _messageController.text.trim()));
    _messageController.clear();

    // Auto scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _pickImage() async {
    final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      context.read<ChatBloc>().add(SendImageMessageEvent(imagePath: image.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: _buildAppBar(),
      body: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is ChatError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ChatLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is! ChatLoaded) {
            return const Center(child: Text('Unable to load chat'));
          }

          return Column(
            children: [
              // Typing indicator
              if (state.isOtherUserTyping)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  color: Colors.grey[200],
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: widget.driverImage != null
                            ? NetworkImage(widget.driverImage!)
                            : null,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${widget.driverName ?? 'Driver'} is typing...',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),

              // Messages List
              Expanded(
                child: state.isLoadingMore
                    ? Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          ),
                          Expanded(child: _buildMessagesList(state.messages)),
                        ],
                      )
                    : _buildMessagesList(state.messages),
              ),

              // Input Bar
              _buildInputBar(),
            ],
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back, color: Colors.black),
      ),
      title: Column(
        children: [
          Text(
            'Your delivery boy',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.grey[600],
            ),
          ),
          Text(
            widget.driverName ?? 'Driver',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.black,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: CircleAvatar(
            radius: 24,
            backgroundColor: Colors.grey[300],
            backgroundImage: widget.driverImage != null ? NetworkImage(widget.driverImage!) : null,
            child: widget.driverImage == null
                ? Icon(Icons.person, color: Colors.grey[600], size: 28)
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildMessagesList(List<MessageEntity> messages) {
    if (messages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No messages yet',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'Start a conversation!',
              style: TextStyle(fontSize: 14, color: Colors.grey[400]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return _buildMessageBubble(message);
      },
    );
  }

  Widget _buildInputBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SafeArea(
        child: Row(
          children: [
            // Camera Button
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(24),
              ),
              child: IconButton(
                onPressed: _pickImage,
                icon: const Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.black,
                  size: 24,
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Text Input
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Type your message...',
                    hintStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[400],
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Send Button
            GestureDetector(
              onTap: _sendMessage,
              child: Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(MessageEntity message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Sender label
          Padding(
            padding: EdgeInsets.only(
              left: message.isMe ? 0 : 60,
              right: message.isMe ? 60 : 0,
              bottom: 8,
            ),
            child: Text(
              message.isMe ? 'You' : message.senderName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),

          // Message bubble with avatar
          Row(
            mainAxisAlignment: message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!message.isMe) ...[
                // Driver avatar (left side)
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: message.senderImageUrl != null
                      ? NetworkImage(message.senderImageUrl!)
                      : null,
                  child: message.senderImageUrl == null
                      ? Icon(Icons.person, color: Colors.grey[600], size: 24)
                      : null,
                ),
                const SizedBox(width: 12),
              ],

              // Message content
              Flexible(
                child: _buildMessageContent(message),
              ),

              if (message.isMe) ...[
                const SizedBox(width: 12),
                // User avatar (right side)
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: Color(0xFFFFB84D),
                  child: Icon(Icons.person, color: Colors.white, size: 24),
                ),
              ],
            ],
          ),

          // Message status (for sent messages)
          if (message.isMe)
            Padding(
              padding: const EdgeInsets.only(top: 4, right: 52),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    _getStatusIcon(message.status),
                    size: 14,
                    color: Colors.grey[500],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _getStatusText(message.status),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMessageContent(MessageEntity message) {
    switch (message.type) {
      case MessageType.image:
        return _buildImageMessage(message);
      case MessageType.file:
        return _buildFileMessage(message);
      case MessageType.system:
        return _buildSystemMessage(message);
      case MessageType.text:
      default:
        return _buildTextMessage(message);
    }
  }

  Widget _buildTextMessage(MessageEntity message) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: message.isMe ? const Color(0xFFFFF4E6) : Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(20),
          topRight: const Radius.circular(20),
          bottomLeft: Radius.circular(message.isMe ? 20 : 4),
          bottomRight: Radius.circular(message.isMe ? 4 : 20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        message.content,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.black,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildImageMessage(MessageEntity message) {
    return Column(
      crossAxisAlignment: message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        if (message.imageUrl != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              message.imageUrl!,
              width: 200,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 200,
                  height: 200,
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image, size: 48),
                );
              },
            ),
          ),
        if (message.content.isNotEmpty && message.content != 'Image')
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: _buildTextMessage(message),
          ),
      ],
    );
  }

  Widget _buildFileMessage(MessageEntity message) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: message.isMe ? const Color(0xFFFFF4E6) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.insert_drive_file, size: 32, color: Colors.blue),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              message.fileName ?? message.content,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemMessage(MessageEntity message) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        message.content,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[700],
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  IconData _getStatusIcon(MessageStatus status) {
    switch (status) {
      case MessageStatus.sending:
        return Icons.access_time;
      case MessageStatus.sent:
        return Icons.done;
      case MessageStatus.delivered:
        return Icons.done_all;
      case MessageStatus.read:
        return Icons.done_all;
      case MessageStatus.failed:
        return Icons.error_outline;
    }
  }

  String _getStatusText(MessageStatus status) {
    switch (status) {
      case MessageStatus.sending:
        return 'Sending...';
      case MessageStatus.sent:
        return 'Sent';
      case MessageStatus.delivered:
        return 'Delivered';
      case MessageStatus.read:
        return 'Read';
      case MessageStatus.failed:
        return 'Failed';
    }
  }
}
