import 'package:flutter/material.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../core/constants/constants.dart';

/// Chef messages screen for customer communications
/// Follows architecture rules: uses constants, shared widgets
class ChefMessagesScreen extends StatelessWidget {
  const ChefMessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final conversations = [
      {
        'name': 'أحمد محمد',
        'lastMessage': 'هل يمكن إضافة طلب إضافي؟',
        'time': '10:30',
        'unread': 2,
        'orderId': '#1234',
      },
      {
        'name': 'فاطمة الزهراء',
        'lastMessage': 'شكراً لك، الطعام كان رائعاً',
        'time': 'أمس',
        'unread': 0,
        'orderId': '#1233',
      },
      {
        'name': 'محمد علي',
        'lastMessage': 'متى يصل الطلب؟',
        'time': 'أمس',
        'unread': 0,
        'orderId': '#1232',
      },
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_forward_ios,
              color: AppColors.textPrimary,
              size: AppDimensions.iconMedium,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: ArabicText(
            text: 'الرسائل',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          centerTitle: true,
        ),
        body: conversations.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      size: AppDimensions.iconXXLarge,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(height: AppDimensions.spacing16),
                    ArabicText(
                      text: 'لا توجد محادثات',
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.all(AppDimensions.spacing20),
                itemCount: conversations.length,
                itemBuilder: (context, index) {
                  final conversation = conversations[index];
                  return _buildConversationCard(context, conversation);
                },
              ),
      ),
    );
  }

  Widget _buildConversationCard(BuildContext context, Map<String, dynamic> conversation) {
    final hasUnread = conversation['unread'] > 0;
    
    return InkWell(
      onTap: () {
        // Navigate to chat screen
      },
      child: Container(
        padding: EdgeInsets.all(AppDimensions.spacing16),
        margin: EdgeInsets.only(bottom: AppDimensions.spacing12),
        decoration: BoxDecoration(
          color: hasUnread ? AppColors.primary.withOpacity(0.05) : AppColors.backgroundGrey,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          border: hasUnread 
              ? Border.all(color: AppColors.primary.withOpacity(0.3))
              : null,
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: ArabicText(
                text: conversation['name'][0],
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            SizedBox(width: AppDimensions.spacing12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ArabicText(
                        text: conversation['name'],
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      ArabicText(
                        text: conversation['time'],
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                  SizedBox(height: AppDimensions.spacing4),
                  Row(
                    children: [
                      Expanded(
                        child: ArabicText(
                          text: conversation['lastMessage'],
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          maxLines: 1,
                        ),
                      ),
                      if (hasUnread)
                        Container(
                          margin: EdgeInsets.only(right: AppDimensions.spacing8),
                          padding: EdgeInsets.symmetric(
                            horizontal: AppDimensions.spacing8,
                            vertical: AppDimensions.spacing4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                          ),
                          child: ArabicText(
                            text: '${conversation['unread']}',
                            fontSize: 12,
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: AppDimensions.spacing4),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.spacing8,
                      vertical: AppDimensions.spacing4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                    ),
                    child: ArabicText(
                      text: 'طلب ${conversation['orderId']}',
                      fontSize: 11,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
