import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../core/constants/constants.dart';
import '../../providers/providers.dart';
import '../../models/models.dart';

/// Chat screen - chat with delivery driver
/// Follows architecture rules: uses Riverpod, constants, shared widgets
class ChatScreen extends ConsumerStatefulWidget {
  final String orderId;

  const ChatScreen({
    super.key,
    required this.orderId,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Load messages when screen opens
    Future.microtask(() {
      ref.read(chatProvider.notifier).loadMessages(widget.orderId);
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    
    ref.read(chatProvider.notifier).sendMessage(
      widget.orderId,
      _messageController.text,
    );
    
    _messageController.clear();
    
    // Scroll to bottom after sending
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

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider);
    final messages = chatState.messages;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.close,
              color: AppColors.textPrimary,
              size: AppDimensions.iconLarge,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.backgroundGrey,
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: Image.network(
                    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.person,
                        color: AppColors.textSecondary,
                        size: 24,
                      );
                    },
                  ),
                ),
              ),
              SizedBox(width: AppDimensions.spacing12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ArabicText(
                      text: 'أحمد محمد',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    ArabicText(
                      text: 'متصل',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.success,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: chatState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : messages.isEmpty
                      ? Center(
                          child: ArabicText(
                            text: 'لا توجد رسائل',
                            fontSize: 16,
                            color: AppColors.textSecondary,
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          padding: EdgeInsets.all(AppDimensions.spacing16),
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final message = messages[index];
                            return _MessageBubble(message: message);
                          },
                        ),
            ),
            
            // Message input
            _MessageInput(
              controller: _messageController,
              onSend: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}

/// Message bubble widget
class _MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isMe = message.sender == MessageSender.user;
    
    return Padding(
      padding: EdgeInsets.only(bottom: AppDimensions.spacing16),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.backgroundGrey,
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: Image.network(
                  'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.person,
                      color: AppColors.textSecondary,
                      size: 20,
                    );
                  },
                ),
              ),
            ),
            SizedBox(width: AppDimensions.spacing8),
          ],
          
          Flexible(
            child: Column(
              crossAxisAlignment: isMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacing16,
                    vertical: AppDimensions.spacing12,
                  ),
                  decoration: BoxDecoration(
                    color: isMe
                        ? AppColors.primary
                        : AppColors.backgroundGrey,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                  ),
                  child: ArabicText(
                    text: message.message,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: isMe ? AppColors.white : AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: AppDimensions.spacing4),
                ArabicText(
                  text: _formatTime(message.timestamp),
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
          
          if (isMe) ...[
            SizedBox(width: AppDimensions.spacing8),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person,
                color: AppColors.white,
                size: 20,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }
}

/// Message input widget
class _MessageInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const _MessageInput({
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.spacing16),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Emoji button
          GestureDetector(
            onTap: () {
              // Emoji picker functionality
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.backgroundGrey,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.emoji_emotions_outlined,
                color: AppColors.textSecondary,
                size: 20,
              ),
            ),
          ),
          
          SizedBox(width: AppDimensions.spacing12),
          
          // Text input
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
              decoration: BoxDecoration(
                color: AppColors.backgroundGrey,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: controller,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'اكتب رسالة...',
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: AppDimensions.spacing12,
                  ),
                ),
                onSubmitted: (_) => onSend(),
              ),
            ),
          ),
          
          SizedBox(width: AppDimensions.spacing12),
          
          // Send button
          GestureDetector(
            onTap: onSend,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.send,
                color: AppColors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
