import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../core/constants/constants.dart';
import '../../providers/providers.dart';
import '../../models/models.dart';
import 'chef_delivery_person_details_screen.dart';
import 'chef_add_delivery_person_screen.dart';

/// Chef delivery team screen showing delivery persons
/// Follows architecture rules: uses Riverpod, constants, shared widgets
class ChefDeliveryTeamScreen extends ConsumerWidget {
  const ChefDeliveryTeamScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamState = ref.watch(deliveryTeamProvider);
    final team = teamState.team;

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
            text: 'فريق التوصيل',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(
                Icons.add,
                color: AppColors.primary,
                size: AppDimensions.iconLarge,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChefAddDeliveryPersonScreen(),
                  ),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            // Stats cards with gradient background
            Container(
              margin: EdgeInsets.all(AppDimensions.spacing20),
              padding: EdgeInsets.all(AppDimensions.spacing20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.people,
                        color: AppColors.white,
                        size: AppDimensions.iconLarge,
                      ),
                      SizedBox(width: AppDimensions.spacing12),
                      ArabicText(
                        text: 'إحصائيات الفريق',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ],
                  ),
                  SizedBox(height: AppDimensions.spacing20),
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          title: 'متاح',
                          count: teamState.availablePersons.length,
                          color: AppColors.success,
                          icon: Icons.check_circle,
                        ),
                      ),
                      SizedBox(width: AppDimensions.spacing12),
                      Expanded(
                        child: _StatCard(
                          title: 'مشغول',
                          count: teamState.busyPersons.length,
                          color: AppColors.warning,
                          icon: Icons.delivery_dining,
                        ),
                      ),
                      SizedBox(width: AppDimensions.spacing12),
                      Expanded(
                        child: _StatCard(
                          title: 'غير متصل',
                          count: teamState.offlinePersons.length,
                          color: AppColors.textSecondary,
                          icon: Icons.offline_bolt,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Team list
            Expanded(
              child: team.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.people_outline,
                            size: AppDimensions.iconXXLarge,
                            color: AppColors.textSecondary,
                          ),
                          SizedBox(height: AppDimensions.spacing16),
                          ArabicText(
                            text: 'لا يوجد أعضاء في الفريق',
                            fontSize: 16,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacing20),
                      itemCount: team.length,
                      itemBuilder: (context, index) {
                        final person = team[index];
                        return _DeliveryPersonCard(
                          person: person,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChefDeliveryPersonDetailsScreen(person: person),
                              ),
                            );
                          },
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

/// Stat card widget
class _StatCard extends StatelessWidget {
  final String title;
  final int count;
  final Color color;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.count,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.spacing12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
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
            text: '$count',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
          SizedBox(height: AppDimensions.spacing4),
          ArabicText(
            text: title,
            fontSize: 12,
            color: AppColors.white.withOpacity(0.9),
          ),
        ],
      ),
    );
  }
}

/// Delivery person card widget
class _DeliveryPersonCard extends StatelessWidget {
  final ChefDeliveryPerson person;
  final VoidCallback onTap;

  const _DeliveryPersonCard({
    required this.person,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppDimensions.spacing16),
        margin: EdgeInsets.only(bottom: AppDimensions.spacing12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          border: Border.all(
            color: _getStatusColor(person.status).withOpacity(0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimary.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _getStatusColor(person.status),
                  width: 3,
                ),
              ),
              child: CircleAvatar(
                radius: 30,
                backgroundColor: _getStatusColor(person.status).withOpacity(0.1),
                child: ArabicText(
                  text: person.name[0],
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _getStatusColor(person.status),
                ),
              ),
            ),
            SizedBox(width: AppDimensions.spacing16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ArabicText(
                          text: person.name,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimensions.spacing8,
                          vertical: AppDimensions.spacing4,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(person.status),
                          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                        ),
                        child: ArabicText(
                          text: person.status.displayName,
                          fontSize: 11,
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppDimensions.spacing8),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 16,
                        color: AppColors.warning,
                      ),
                      SizedBox(width: AppDimensions.spacing4),
                      ArabicText(
                        text: person.rating.toStringAsFixed(1),
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(width: AppDimensions.spacing12),
                      Icon(
                        Icons.delivery_dining,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: AppDimensions.spacing4),
                      ArabicText(
                        text: '${person.totalDeliveries} توصيلة',
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                  SizedBox(height: AppDimensions.spacing4),
                  Row(
                    children: [
                      Icon(
                        Icons.two_wheeler,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(width: AppDimensions.spacing4),
                      ArabicText(
                        text: person.vehicle.type,
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
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
}
