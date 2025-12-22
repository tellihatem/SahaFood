import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';

/// Chef state containing orders and statistics
class ChefState {
  final List<ChefOrder> orders;
  final int runningOrdersCount;
  final int todayOrdersCount;
  final double todayRevenue;
  final double averageRating;
  final int totalReviews;

  ChefState({
    this.orders = const [],
    this.runningOrdersCount = 0,
    this.todayOrdersCount = 0,
    this.todayRevenue = 0.0,
    this.averageRating = 0.0,
    this.totalReviews = 0,
  });

  ChefState copyWith({
    List<ChefOrder>? orders,
    int? runningOrdersCount,
    int? todayOrdersCount,
    double? todayRevenue,
    double? averageRating,
    int? totalReviews,
  }) {
    return ChefState(
      orders: orders ?? this.orders,
      runningOrdersCount: runningOrdersCount ?? this.runningOrdersCount,
      todayOrdersCount: todayOrdersCount ?? this.todayOrdersCount,
      todayRevenue: todayRevenue ?? this.todayRevenue,
      averageRating: averageRating ?? this.averageRating,
      totalReviews: totalReviews ?? this.totalReviews,
    );
  }
}

/// Chef provider with state management
class ChefNotifier extends StateNotifier<ChefState> {
  ChefNotifier() : super(ChefState()) {
    _initializeMockData();
  }

  /// Initialize with mock data for development
  void _initializeMockData() {
    final mockOrders = [
      ChefOrder(
        id: '1',
        orderNumber: '#1234',
        customerName: 'أحمد محمد',
        customerPhone: '+213 555 111 222',
        customerAddress: 'شارع الاستقلال، الجزائر',
        items: [
          OrderItem(
            foodId: '1',
            foodName: 'برجر لحم',
            quantity: 2,
            price: 1200.0,
          ),
          OrderItem(
            foodId: '2',
            foodName: 'بطاطس مقلية',
            quantity: 1,
            price: 400.0,
          ),
        ],
        totalPrice: 2800.0,
        status: ChefOrderStatus.pending,
        orderTime: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      ChefOrder(
        id: '2',
        orderNumber: '#1235',
        customerName: 'فاطمة الزهراء',
        customerPhone: '+213 555 333 444',
        customerAddress: 'حي السعادة، وهران',
        items: [
          OrderItem(
            foodId: '3',
            foodName: 'كسكس بالدجاج',
            quantity: 1,
            price: 1500.0,
          ),
        ],
        totalPrice: 1500.0,
        status: ChefOrderStatus.preparing,
        orderTime: DateTime.now().subtract(const Duration(minutes: 15)),
      ),
      ChefOrder(
        id: '3',
        orderNumber: '#1236',
        customerName: 'محمد علي',
        customerPhone: '+213 555 555 666',
        customerAddress: 'شارع ديدوش مراد، قسنطينة',
        items: [
          OrderItem(
            foodId: '4',
            foodName: 'بيتزا مارغريتا',
            quantity: 2,
            price: 1800.0,
          ),
        ],
        totalPrice: 3600.0,
        status: ChefOrderStatus.ready,
        orderTime: DateTime.now().subtract(const Duration(minutes: 25)),
        deliveryPersonName: 'كريم عبدالله',
      ),
    ];

    state = state.copyWith(
      orders: mockOrders,
      runningOrdersCount: 20,
      todayOrdersCount: 5,
      todayRevenue: 25000.0,
      averageRating: 4.8,
      totalReviews: 156,
    );
  }

  /// Accept pending order
  void acceptOrder(String orderId) {
    final updatedOrders = state.orders.map((order) {
      if (order.id == orderId && order.status == ChefOrderStatus.pending) {
        return order.copyWith(status: ChefOrderStatus.preparing);
      }
      return order;
    }).toList();

    state = state.copyWith(orders: updatedOrders);
  }

  /// Mark order as ready for delivery
  void markAsReady(String orderId) {
    final updatedOrders = state.orders.map((order) {
      if (order.id == orderId && order.status == ChefOrderStatus.preparing) {
        return order.copyWith(status: ChefOrderStatus.ready);
      }
      return order;
    }).toList();

    state = state.copyWith(orders: updatedOrders);
  }

  /// Assign delivery person to order
  void assignDeliveryPerson(String orderId, String deliveryPersonId, String deliveryPersonName) {
    final updatedOrders = state.orders.map((order) {
      if (order.id == orderId) {
        return order.copyWith(
          deliveryPersonId: deliveryPersonId,
          deliveryPersonName: deliveryPersonName,
          status: ChefOrderStatus.outForDelivery,
        );
      }
      return order;
    }).toList();

    state = state.copyWith(orders: updatedOrders);
  }

  /// Cancel order
  void cancelOrder(String orderId, String reason) {
    final updatedOrders = state.orders.map((order) {
      if (order.id == orderId) {
        return order.copyWith(
          status: ChefOrderStatus.cancelled,
          notes: reason,
        );
      }
      return order;
    }).toList();

    state = state.copyWith(orders: updatedOrders);
  }

  /// Get orders by status
  List<ChefOrder> getOrdersByStatus(ChefOrderStatus status) {
    return state.orders.where((order) => order.status == status).toList();
  }

  /// Get running orders (preparing + ready + out for delivery)
  List<ChefOrder> getRunningOrders() {
    return state.orders.where((order) =>
      order.status == ChefOrderStatus.preparing ||
      order.status == ChefOrderStatus.ready ||
      order.status == ChefOrderStatus.outForDelivery
    ).toList();
  }
}

/// Provider instance
final chefProvider = StateNotifierProvider<ChefNotifier, ChefState>((ref) {
  return ChefNotifier();
});
