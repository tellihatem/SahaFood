import 'package:flutter/material.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../core/constants/constants.dart';

/// Verification screen - TODO: Fully refactor this screen
class VerificationScreen extends StatelessWidget {
  final String phoneNumber;
  
  const VerificationScreen({
    Key? key,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundDark,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: AppColors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: ArabicText(
            text: 'التحقق من الرمز',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.verified_user,
                  size: 100,
                  color: AppColors.primary,
                ),
                SizedBox(height: 24),
                ArabicText(
                  text: 'التحقق من الهاتف',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                SizedBox(height: 16),
                ArabicText(
                  text: 'رقم الهاتف: $phoneNumber',
                  fontSize: 16,
                  color: AppColors.textSecondary,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                ArabicText(
                  text: 'قيد التطوير - سيتم إضافة النموذج الكامل قريباً',
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
