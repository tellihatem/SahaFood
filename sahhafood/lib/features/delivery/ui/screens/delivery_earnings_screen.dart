import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../core/constants/constants.dart';

/// Delivery earnings screen with period selector and stats
/// Shows total earnings, orders, tips, and bonus
class DeliveryEarningsScreen extends StatefulWidget {
  const DeliveryEarningsScreen({super.key});

  @override
  State<DeliveryEarningsScreen> createState() => _DeliveryEarningsScreenState();
}

class _DeliveryEarningsScreenState extends State<DeliveryEarningsScreen> {
  String selectedPeriod = 'week'; // week, month, year

  final Map<String, Map<String, dynamic>> earningsData = {
    'week': {
      'total': 8500,
      'orders': 42,
      'tips': 1250,
      'bonus': 500,
    },
    'month': {
      'total': 34200,
      'orders': 168,
      'tips': 4800,
      'bonus': 2000,
    },
    'year': {
      'total': 386500,
      'orders': 1850,
      'tips': 52000,
      'bonus': 24000,
    },
  };

  final List<Map<String, dynamic>> recentEarnings = [
    {
      'date': '15 أكتوبر 2025',
      'orders': 8,
      'amount': 1800,
      'tips': 250,
    },
    {
      'date': '14 أكتوبر 2025',
      'orders': 12,
      'amount': 2450,
      'tips': 350,
    },
    {
      'date': '13 أكتوبر 2025',
      'orders': 6,
      'amount': 1250,
      'tips': 150,
    },
    {
      'date': '12 أكتوبر 2025',
      'orders': 10,
      'amount': 2100,
      'tips': 300,
    },
    {
      'date': '11 أكتوبر 2025',
      'orders': 6,
      'amount': 890,
      'tips': 200,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final currentData = earningsData[selectedPeriod]!;

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
            text: 'الأرباح',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Period selector
              Container(
                margin: EdgeInsets.all(AppDimensions.spacing16),
                padding: EdgeInsets.all(AppDimensions.spacing4),
                decoration: BoxDecoration(
                  color: AppColors.backgroundGrey,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                ),
                child: Row(
                  children: [
                    _buildPeriodButton('أسبوع', 'week'),
                    _buildPeriodButton('شهر', 'month'),
                    _buildPeriodButton('سنة', 'year'),
                  ],
                ),
              ),

              // Total earnings card
              Container(
                margin: EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
                padding: EdgeInsets.all(AppDimensions.spacing24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ArabicText(
                      text: 'إجمالي الأرباح',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.white.withOpacity(0.9),
                    ),
                    SizedBox(height: AppDimensions.spacing8),
                    ArabicText(
                      text: '${currentData['total']} دج',
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                    SizedBox(height: AppDimensions.spacing16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(
                          icon: Icons.delivery_dining,
                          label: 'طلبات',
                          value: '${currentData['orders']}',
                        ),
                        Container(
                          width: 1,
                          height: 30.h,
                          color: AppColors.white.withOpacity(0.3),
                        ),
                        _buildStatItem(
                          icon: Icons.attach_money,
                          label: 'إكراميات',
                          value: '${currentData['tips']} دج',
                        ),
                        Container(
                          width: 1,
                          height: 30.h,
                          color: AppColors.white.withOpacity(0.3),
                        ),
                        _buildStatItem(
                          icon: Icons.card_giftcard,
                          label: 'مكافآت',
                          value: '${currentData['bonus']} دج',
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: AppDimensions.spacing24),

              // Recent earnings
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ArabicText(
                      text: 'الأرباح الأخيرة',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    TextButton(
                      onPressed: () {},
                      child: ArabicText(
                        text: 'عرض الكل',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
                itemCount: recentEarnings.length,
                itemBuilder: (context, index) {
                  final earning = recentEarnings[index];
                  return _buildEarningCard(earning);
                },
              ),

              SizedBox(height: AppDimensions.spacing24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPeriodButton(String title, String period) {
    final isSelected = selectedPeriod == period;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedPeriod = period;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: AppDimensions.spacing12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
          ),
          child: Center(
            child: ArabicText(
              text: title,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isSelected ? AppColors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppColors.white,
          size: AppDimensions.iconMedium,
        ),
        SizedBox(height: AppDimensions.spacing4),
        ArabicText(
          text: value,
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: AppColors.white,
        ),
        ArabicText(
          text: label,
          fontSize: 11,
          fontWeight: FontWeight.w400,
          color: AppColors.white.withOpacity(0.8),
        ),
      ],
    );
  }

  Widget _buildEarningCard(Map<String, dynamic> earning) {
    return Container(
      margin: EdgeInsets.only(bottom: AppDimensions.spacing12),
      padding: EdgeInsets.all(AppDimensions.spacing16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(
          color: AppColors.borderLight,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            ),
            child: Icon(
              Icons.account_balance_wallet,
              color: AppColors.success,
              size: AppDimensions.iconLarge,
            ),
          ),
          SizedBox(width: AppDimensions.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ArabicText(
                  text: earning['date'],
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                SizedBox(height: AppDimensions.spacing4),
                ArabicText(
                  text: '${earning['orders']} طلبات',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ArabicText(
                text: '${earning['amount']} دج',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.success,
              ),
              SizedBox(height: 2.h),
              Row(
                children: [
                  Icon(
                    Icons.add_circle,
                    size: 12.w,
                    color: AppColors.warning,
                  ),
                  SizedBox(width: AppDimensions.spacing4),
                  ArabicText(
                    text: '${earning['tips']} دج',
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.warning,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
