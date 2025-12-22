import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../core/constants/constants.dart';
import '../../providers/providers.dart';
import 'add_address_screen.dart';

/// Addresses screen - displays and manages user addresses
/// Follows architecture rules: uses Riverpod, constants, shared widgets
class AddressesScreen extends ConsumerWidget {
  const AddressesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addressState = ref.watch(addressProvider);
    final addresses = addressState.addresses;

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
            text: 'عناويني',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: addresses.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.location_off_outlined,
                            size: 64,
                            color: AppColors.textSecondary,
                          ),
                          SizedBox(height: AppDimensions.spacing16),
                          ArabicText(
                            text: 'لا توجد عناوين محفوظة',
                            fontSize: 16,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.all(AppDimensions.spacing24),
                      itemCount: addresses.length,
                      itemBuilder: (context, index) {
                        final address = addresses[index];
                        return _AddressCard(
                          address: address,
                          index: index,
                        );
                      },
                    ),
            ),
            
            // Add new address button
            Padding(
              padding: EdgeInsets.all(AppDimensions.spacing24),
              child: CustomButton(
                text: 'إضافة عنوان جديد',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddAddressScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Address card widget
class _AddressCard extends ConsumerWidget {
  final dynamic address;
  final int index;

  const _AddressCard({
    required this.address,
    required this.index,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Determine icon and color based on label
    IconData icon;
    Color color;
    
    if (address.label == 'المنزل') {
      icon = Icons.home_outlined;
      color = AppColors.success;
    } else if (address.label == 'العمل') {
      icon = Icons.work_outline;
      color = const Color(0xFF6C5CE7);
    } else {
      icon = Icons.location_on_outlined;
      color = AppColors.primary;
    }

    return Container(
      margin: EdgeInsets.only(bottom: AppDimensions.spacing16),
      padding: EdgeInsets.all(AppDimensions.spacing16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(
          color: color.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
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
                Row(
                  children: [
                    ArabicText(
                      text: address.label,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    if (address.isDefault) ...[
                      SizedBox(width: AppDimensions.spacing8),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimensions.spacing8,
                          vertical: AppDimensions.spacing4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                        ),
                        child: ArabicText(
                          text: 'افتراضي',
                          fontSize: 10,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: AppDimensions.spacing4),
                ArabicText(
                  text: address.fullAddress,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                  maxLines: 2,
                ),
                if (address.building != null || address.floor != null || address.apartment != null) ...[
                  SizedBox(height: AppDimensions.spacing4),
                  ArabicText(
                    text: [
                      if (address.building != null) 'مبنى ${address.building}',
                      if (address.floor != null) 'طابق ${address.floor}',
                      if (address.apartment != null) 'شقة ${address.apartment}',
                    ].join(' - '),
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: AppDimensions.spacing8),
          Column(
            children: [
              IconButton(
                icon: Icon(
                  Icons.edit_outlined,
                  color: AppColors.primary,
                  size: AppDimensions.iconMedium,
                ),
                onPressed: () {
                  // TODO: Navigate to edit address screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('تعديل العنوان: ${address.label}'),
                      backgroundColor: AppColors.info,
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  color: AppColors.error,
                  size: AppDimensions.iconMedium,
                ),
                onPressed: () => _showDeleteDialog(context, ref, address.id),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref, String addressId) {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: ArabicText(
            text: 'حذف العنوان',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          content: ArabicText(
            text: 'هل أنت متأكد من حذف هذا العنوان؟',
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
              onPressed: () async {
                final success = await ref
                    .read(addressProvider.notifier)
                    .deleteAddress(addressId);
                
                if (context.mounted) {
                  Navigator.pop(context);
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('تم حذف العنوان بنجاح'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  }
                }
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
