import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../core/constants/constants.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';

/// Chef delivery person details screen
/// Follows architecture rules: uses Riverpod, constants, shared widgets
class ChefDeliveryPersonDetailsScreen extends ConsumerWidget {
  final ChefDeliveryPerson person;

  const ChefDeliveryPersonDetailsScreen({
    super.key,
    required this.person,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            text: 'تفاصيل السائق',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(AppDimensions.spacing20),
          child: Column(
            children: [
              // Profile section
              Container(
                padding: EdgeInsets.all(AppDimensions.spacing24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_getStatusColor(person.status), _getStatusColor(person.status).withOpacity(0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.white,
                      child: ArabicText(
                        text: person.name[0],
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: _getStatusColor(person.status),
                      ),
                    ),
                    SizedBox(height: AppDimensions.spacing16),
                    ArabicText(
                      text: person.name,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                    SizedBox(height: AppDimensions.spacing8),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimensions.spacing16,
                        vertical: AppDimensions.spacing8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                      ),
                      child: ArabicText(
                        text: person.status.displayName,
                        fontSize: 14,
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: AppDimensions.spacing24),

              // Stats cards
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      icon: Icons.star,
                      title: 'التقييم',
                      value: person.rating.toStringAsFixed(1),
                      color: AppColors.warning,
                    ),
                  ),
                  SizedBox(width: AppDimensions.spacing12),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.delivery_dining,
                      title: 'التوصيلات',
                      value: '${person.totalDeliveries}',
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),

              SizedBox(height: AppDimensions.spacing24),

              // Contact section
              SectionHeader(title: 'معلومات الاتصال'),
              SizedBox(height: AppDimensions.spacing12),
              _InfoItem(
                icon: Icons.phone,
                title: 'رقم الهاتف',
                value: person.phone,
                onTap: () async {
                  final url = Uri.parse('tel:${person.phone}');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                },
              ),
              _InfoItem(
                icon: Icons.email,
                title: 'البريد الإلكتروني',
                value: person.email,
                onTap: () async {
                  final url = Uri.parse('mailto:${person.email}');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                },
              ),

              SizedBox(height: AppDimensions.spacing24),

              // Vehicle section
              SectionHeader(title: 'معلومات المركبة'),
              SizedBox(height: AppDimensions.spacing12),
              Container(
                padding: EdgeInsets.all(AppDimensions.spacing16),
                decoration: BoxDecoration(
                  color: AppColors.backgroundGrey,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                ),
                child: Column(
                  children: [
                    _InfoRow(title: 'النوع', value: person.vehicle.type),
                    Divider(height: AppDimensions.spacing24, color: AppColors.borderLight),
                    _InfoRow(title: 'الموديل', value: person.vehicle.model),
                    Divider(height: AppDimensions.spacing24, color: AppColors.borderLight),
                    _InfoRow(title: 'رقم اللوحة', value: person.vehicle.plateNumber),
                    if (person.vehicle.color != null) ...[
                      Divider(height: AppDimensions.spacing24, color: AppColors.borderLight),
                      _InfoRow(title: 'اللون', value: person.vehicle.color!),
                    ],
                  ],
                ),
              ),

              SizedBox(height: AppDimensions.spacing24),

              // Current order (if busy)
              if (person.status == ChefDeliveryPersonStatus.busy && person.currentOrderId != null) ...[
                SectionHeader(title: 'الطلب الحالي'),
                SizedBox(height: AppDimensions.spacing12),
                Container(
                  padding: EdgeInsets.all(AppDimensions.spacing16),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                    border: Border.all(color: AppColors.warning.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.receipt_long,
                        color: AppColors.warning,
                        size: AppDimensions.iconLarge,
                      ),
                      SizedBox(width: AppDimensions.spacing12),
                      Expanded(
                        child: ArabicText(
                          text: 'طلب ${person.currentOrderId}',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      ArabicText(
                        text: 'في الطريق',
                        fontSize: 14,
                        color: AppColors.warning,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppDimensions.spacing24),
              ],

              // Actions
              CustomButton(
                text: 'حذف السائق',
                onPressed: () {
                  _showDeleteDialog(context, ref);
                },
                backgroundColor: AppColors.error.withOpacity(0.1),
                textColor: AppColors.error,
                height: 48,
              ),

              SizedBox(height: AppDimensions.spacing24),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(ChefDeliveryPersonStatus status) {
    switch (status) {
      case ChefDeliveryPersonStatus.available:
        return AppColors.success;
      case ChefDeliveryPersonStatus.busy:
        return AppColors.warning;
      case ChefDeliveryPersonStatus.offline:
        return AppColors.textSecondary;
    }
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const ArabicText(
            text: 'حذف السائق',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          content: ArabicText(
            text: 'هل أنت متأكد من حذف "${person.name}"؟',
            fontSize: 14,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: ArabicText(
                text: 'إلغاء',
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            TextButton(
              onPressed: () {
                ref.read(deliveryTeamProvider.notifier).removeDeliveryPerson(person.id);
                Navigator.pop(context);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('تم حذف السائق'),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
              child: ArabicText(
                text: 'حذف',
                fontSize: 14,
                color: AppColors.error,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Stat card widget
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.spacing16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: AppDimensions.iconLarge,
          ),
          SizedBox(height: AppDimensions.spacing8),
          ArabicText(
            text: title,
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: AppDimensions.spacing4),
          ArabicText(
            text: value,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ],
      ),
    );
  }
}

/// Info item widget
class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback? onTap;

  const _InfoItem({
    required this.icon,
    required this.title,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppDimensions.spacing16),
        margin: EdgeInsets.only(bottom: AppDimensions.spacing12),
        decoration: BoxDecoration(
          color: AppColors.backgroundGrey,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.primary,
              size: AppDimensions.iconLarge,
            ),
            SizedBox(width: AppDimensions.spacing16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ArabicText(
                    text: title,
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(height: AppDimensions.spacing4),
                  ArabicText(
                    text: value,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.arrow_back_ios,
                size: AppDimensions.iconSmall,
                color: AppColors.textSecondary,
              ),
          ],
        ),
      ),
    );
  }
}

/// Info row widget
class _InfoRow extends StatelessWidget {
  final String title;
  final String value;

  const _InfoRow({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ArabicText(
          text: title,
          fontSize: 14,
          color: AppColors.textSecondary,
        ),
        ArabicText(
          text: value,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ],
    );
  }
}
