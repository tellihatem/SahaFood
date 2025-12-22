import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../core/constants/constants.dart';

/// Delivery support screen with contact options
/// Provides multiple ways to contact support team
class DeliverySupportScreen extends StatelessWidget {
  const DeliverySupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            text: 'المساعدة والدعم',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(AppDimensions.spacing24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Contact Support Card
              Container(
                padding: EdgeInsets.all(AppDimensions.spacing24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.headset_mic,
                      size: 48.w,
                      color: AppColors.white,
                    ),
                    SizedBox(height: AppDimensions.spacing12),
                    ArabicText(
                      text: 'نحن هنا لمساعدتك',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                    SizedBox(height: AppDimensions.spacing8),
                    ArabicText(
                      text: 'فريق الدعم متاح 24/7',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.white.withOpacity(0.9),
                    ),
                  ],
                ),
              ),

              SizedBox(height: AppDimensions.spacing24),

              // Contact Methods
              SectionHeader(title: 'طرق التواصل'),

              SizedBox(height: AppDimensions.spacing12),

              _buildContactTile(
                context,
                icon: Icons.phone,
                title: 'اتصل بنا',
                subtitle: '+213 555 000 000',
                color: AppColors.success,
                onTap: () async {
                  final url = Uri.parse('tel:+213555000000');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                },
              ),

              _buildContactTile(
                context,
                icon: Icons.email,
                title: 'البريد الإلكتروني',
                subtitle: 'support@sahhafood.com',
                color: AppColors.info,
                onTap: () async {
                  final url = Uri.parse('mailto:support@sahhafood.com');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                },
              ),

              _buildContactTile(
                context,
                icon: Icons.chat_bubble,
                title: 'الدردشة المباشرة',
                subtitle: 'ابدأ محادثة مع فريق الدعم',
                color: AppColors.primary,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('سيتم فتح الدردشة المباشرة قريباً'),
                      backgroundColor: AppColors.primary,
                    ),
                  );
                },
              ),

              _buildContactTile(
                context,
                icon: Icons.language,
                title: 'الموقع الإلكتروني',
                subtitle: 'www.sahhafood.com',
                color: AppColors.warning,
                onTap: () async {
                  final url = Uri.parse('https://www.sahhafood.com');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  }
                },
              ),

              SizedBox(height: AppDimensions.spacing24),

              // FAQ Section
              SectionHeader(title: 'الأسئلة الشائعة'),

              SizedBox(height: AppDimensions.spacing12),

              _buildFAQItem(
                question: 'كيف يمكنني تحديث معلوماتي الشخصية؟',
                answer: 'يمكنك تحديث معلوماتك من خلال الذهاب إلى الملف الشخصي ثم المعلومات الشخصية.',
              ),

              _buildFAQItem(
                question: 'كيف يتم حساب الأرباح؟',
                answer: 'يتم حساب الأرباح بناءً على عدد التوصيلات والمسافة المقطوعة بالإضافة إلى الإكراميات.',
              ),

              _buildFAQItem(
                question: 'ماذا أفعل إذا واجهت مشكلة مع طلب؟',
                answer: 'اتصل بفريق الدعم فوراً عبر أحد قنوات التواصل المتاحة وسيتم مساعدتك.',
              ),

              _buildFAQItem(
                question: 'كيف يمكنني تغيير حالة التوفر؟',
                answer: 'يمكنك تغيير حالة التوفر من الملف الشخصي من خلال التبديل بين متاح وغير متاح.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: AppDimensions.spacing12),
        padding: EdgeInsets.all(AppDimensions.spacing16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(AppDimensions.spacing12),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
              ),
              child: Icon(
                icon,
                color: AppColors.white,
                size: AppDimensions.iconLarge,
              ),
            ),
            SizedBox(width: AppDimensions.spacing16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ArabicText(
                    text: title,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  SizedBox(height: AppDimensions.spacing4),
                  ArabicText(
                    text: subtitle,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_back_ios,
              size: AppDimensions.iconSmall,
              color: color,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem({
    required String question,
    required String answer,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: AppDimensions.spacing12),
      padding: EdgeInsets.all(AppDimensions.spacing16),
      decoration: BoxDecoration(
        color: AppColors.backgroundGrey,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.help_outline,
                color: AppColors.primary,
                size: AppDimensions.iconMedium,
              ),
              SizedBox(width: AppDimensions.spacing8),
              Expanded(
                child: ArabicText(
                  text: question,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.spacing8),
          Padding(
            padding: EdgeInsets.only(right: 32.w),
            child: ArabicText(
              text: answer,
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
