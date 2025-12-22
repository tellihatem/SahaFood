import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../core/constants/constants.dart';

/// Delivery chat screen for messaging with customers
/// Simple chat interface with message list and input
class DeliveryChatScreen extends StatefulWidget {
  final String customerName;
  final String orderId;

  const DeliveryChatScreen({
    Key? key,
    required this.customerName,
    this.orderId = '',
  }) : super(key: key);

  @override
  State<DeliveryChatScreen> createState() => _DeliveryChatScreenState();
}

class _DeliveryChatScreenState extends State<DeliveryChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> messages = [
    {
      'text': 'مرحباً، أنا في الطريق إليك',
      'isMe': true,
      'time': '14:30',
    },
    {
      'text': 'شكراً، كم المدة المتوقعة؟',
      'isMe': false,
      'time': '14:31',
    },
    {
      'text': 'حوالي 10 دقائق',
      'isMe': true,
      'time': '14:32',
    },
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        messages.add({
          'text': _messageController.text,
          'isMe': true,
          'time': '${DateTime.now().hour}:${DateTime.now().minute}',
        });
      });
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.backgroundGrey,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 1,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_forward_ios,
              color: AppColors.textPrimary,
              size: AppDimensions.iconMedium,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: Icon(
                  Icons.person,
                  color: AppColors.primary,
                  size: AppDimensions.iconLarge,
                ),
              ),
              SizedBox(width: AppDimensions.spacing12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ArabicText(
                      text: widget.customerName,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    if (widget.orderId.isNotEmpty)
                      ArabicText(
                        text: 'طلب ${widget.orderId}',
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.phone,
                color: AppColors.success,
                size: AppDimensions.iconLarge,
              ),
              onPressed: () {
                // Call customer
              },
            ),
          ],
        ),
        body: Column(
          children: [
            // Messages list
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(AppDimensions.spacing16),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return _buildMessageBubble(message);
                },
              ),
            ),

            // Message input
            Container(
              padding: EdgeInsets.all(AppDimensions.spacing16),
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimensions.spacing16,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundGrey,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                        ),
                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: 'اكتب رسالة...',
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              color: AppColors.textHint,
                              fontSize: 14,
                            ),
                          ),
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                          ),
                          maxLines: null,
                        ),
                      ),
                    ),
                    SizedBox(width: AppDimensions.spacing12),
                    GestureDetector(
                      onTap: _sendMessage,
                      child: Container(
                        width: 48.w,
                        height: 48.w,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.send,
                          color: AppColors.white,
                          size: AppDimensions.iconLarge,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final isMe = message['isMe'] as bool;
    return Align(
      alignment: isMe ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.only(bottom: AppDimensions.spacing8),
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.spacing16,
          vertical: AppDimensions.spacing12,
        ),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppDimensions.radiusLarge),
            topRight: Radius.circular(AppDimensions.radiusLarge),
            bottomLeft: isMe
                ? Radius.circular(AppDimensions.radiusSmall)
                : Radius.circular(AppDimensions.radiusLarge),
            bottomRight: isMe
                ? Radius.circular(AppDimensions.radiusLarge)
                : Radius.circular(AppDimensions.radiusSmall),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ArabicText(
              text: message['text'],
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: isMe ? AppColors.white : AppColors.textPrimary,
            ),
            SizedBox(height: AppDimensions.spacing4),
            ArabicText(
              text: message['time'],
              fontSize: 11,
              color: isMe
                  ? AppColors.white.withOpacity(0.7)
                  : AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
