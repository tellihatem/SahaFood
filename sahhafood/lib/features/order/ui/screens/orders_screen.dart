import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../core/constants/constants.dart';
import '../../providers/providers.dart';
import '../../models/models.dart';
import 'order_tracking_screen.dart';

/// Orders screen - displays ongoing and history orders with tabs
/// Follows architecture rules: uses Riverpod, constants, shared widgets
class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(orderProvider);

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
            text: 'طلباتي',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(
                Icons.more_horiz,
                color: AppColors.textPrimary,
                size: AppDimensions.iconLarge,
              ),
              onPressed: () {},
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: AppColors.primary,
            indicatorWeight: 3,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            labelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            tabs: const [
              Tab(text: 'جاري التنفيذ'),
              Tab(text: 'السجل'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            // Ongoing Orders Tab
            _buildOngoingOrders(orderState.ongoingOrders),
            // History Orders Tab
            _buildHistoryOrders(orderState.historyOrders),
          ],
        ),
      ),
    );
  }

  Widget _buildOngoingOrders(List<Order> orders) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 64,
              color: AppColors.textSecondary,
            ),
            SizedBox(height: AppDimensions.spacing16),
            ArabicText(
              text: 'لا توجد طلبات جارية',
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(AppDimensions.spacing16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return _OngoingOrderCard(order: order);
      },
    );
  }

  Widget _buildHistoryOrders(List<Order> orders) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 64,
              color: AppColors.textSecondary,
            ),
            SizedBox(height: AppDimensions.spacing16),
            ArabicText(
              text: 'لا يوجد سجل طلبات',
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(AppDimensions.spacing16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return _HistoryOrderCard(order: order);
      },
    );
  }
}

/// Ongoing order card widget
class _OngoingOrderCard extends ConsumerWidget {
  final Order order;

  const _OngoingOrderCard({required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: EdgeInsets.only(bottom: AppDimensions.spacing16),
      padding: EdgeInsets.all(AppDimensions.spacing16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.backgroundGrey,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                  child: Image.network(
                    order.restaurantImageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.fastfood,
                        color: AppColors.textSecondary,
                        size: 30,
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
                      text: order.restaurantName,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    SizedBox(height: AppDimensions.spacing4),
                    ArabicText(
                      text: order.orderNumber,
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
                    text: '\$${order.totalPrice.toStringAsFixed(2)}',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  SizedBox(height: AppDimensions.spacing4),
                  ArabicText(
                    text: '${order.totalItems} عناصر',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: AppDimensions.spacing16),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderTrackingScreen(orderId: order.id),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                      ),
                    ),
                    child: ArabicText(
                      text: 'تتبع الطلب',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              SizedBox(width: AppDimensions.spacing12),
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: OutlinedButton(
                    onPressed: () => _showCancelDialog(context, ref, order.id),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.borderLight),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                      ),
                    ),
                    child: ArabicText(
                      text: 'إلغاء',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(BuildContext context, WidgetRef ref, String orderId) {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: ArabicText(
            text: 'إلغاء الطلب',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          content: ArabicText(
            text: 'هل أنت متأكد من إلغاء هذا الطلب؟',
            fontSize: 14,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: ArabicText(
                text: 'رجوع',
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            TextButton(
              onPressed: () async {
                final success = await ref.read(orderProvider.notifier).cancelOrder(orderId);
                if (context.mounted) {
                  Navigator.pop(context);
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('تم إلغاء الطلب بنجاح'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  }
                }
              },
              child: ArabicText(
                text: 'إلغاء الطلب',
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

/// History order card widget
class _HistoryOrderCard extends ConsumerWidget {
  final Order order;

  const _HistoryOrderCard({required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCompleted = order.status == OrderStatus.delivered;

    return Container(
      margin: EdgeInsets.only(bottom: AppDimensions.spacing16),
      padding: EdgeInsets.all(AppDimensions.spacing16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.backgroundGrey,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                  child: Image.network(
                    order.restaurantImageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.fastfood,
                        color: AppColors.textSecondary,
                        size: 30,
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
                    Row(
                      children: [
                        Expanded(
                          child: ArabicText(
                            text: order.restaurantName,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppDimensions.spacing8,
                            vertical: AppDimensions.spacing4,
                          ),
                          decoration: BoxDecoration(
                            color: isCompleted
                                ? AppColors.success.withOpacity(0.1)
                                : AppColors.error.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: ArabicText(
                            text: order.status.displayName,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: isCompleted ? AppColors.success : AppColors.error,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppDimensions.spacing4),
                    ArabicText(
                      text: '${order.orderNumber} • ${_formatDate(order.orderTime)}',
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.spacing12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ArabicText(
                text: '${order.totalItems} عناصر',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
              ),
              ArabicText(
                text: '\$${order.totalPrice.toStringAsFixed(2)}',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ],
          ),
          SizedBox(height: AppDimensions.spacing12),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: OutlinedButton(
                    onPressed: () => _showRatingDialog(context, ref, order.id),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.borderLight),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                      ),
                    ),
                    child: ArabicText(
                      text: 'تقييم',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
              SizedBox(width: AppDimensions.spacing12),
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () async {
                      final success = await ref.read(orderProvider.notifier).reorder(order.id);
                      if (context.mounted && success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('تمت إضافة الطلب إلى السلة'),
                            backgroundColor: AppColors.success,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                      ),
                      elevation: 0,
                    ),
                    child: ArabicText(
                      text: 'إعادة الطلب',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showRatingDialog(BuildContext context, WidgetRef ref, String orderId) {
    double rating = 5.0;
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: ArabicText(
            text: 'تقييم الطلب',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ArabicText(
                text: 'كيف كانت تجربتك؟',
                fontSize: 14,
              ),
              SizedBox(height: AppDimensions.spacing16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return Icon(
                    Icons.star,
                    color: AppColors.warning,
                    size: 32,
                  );
                }),
              ),
            ],
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
                await ref.read(orderProvider.notifier).rateOrder(orderId, rating, null);
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('شكراً لتقييمك'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                }
              },
              child: ArabicText(
                text: 'إرسال',
                fontSize: 14,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
    ];
    return '${date.day} ${months[date.month - 1]}، ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
