import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/models.dart';

/// Order state class
/// Holds the current state of user orders
class OrderState {
  final List<Order> orders;
  final bool isLoading;
  final String? error;

  const OrderState({
    required this.orders,
    this.isLoading = false,
    this.error,
  });

  /// Initial state with mock orders
  factory OrderState.initial() {
    return OrderState(
      orders: [
        Order(
          id: '1',
          orderNumber: '#162432',
          restaurantName: 'بيتزا حارة',
          restaurantImageUrl: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=200',
          items: const [
            OrderItem(name: 'بيتزا مارغريتا', quantity: 2, price: 15.50),
            OrderItem(name: 'بيتزا بيبروني', quantity: 1, price: 18.25),
          ],
          totalPrice: 35.25,
          status: OrderStatus.onTheWay,
          orderTime: DateTime.now().subtract(const Duration(minutes: 30)),
          deliveryAddress: '2118 Thornridge Cir. Syracuse',
          driverName: 'أحمد محمد',
          driverPhone: '+966 55 123 4567',
          driverImageUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=200',
        ),
        Order(
          id: '2',
          orderNumber: '#162433',
          restaurantName: 'ماكدونالدز',
          restaurantImageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=200',
          items: const [
            OrderItem(name: 'بيج ماك', quantity: 2, price: 20.05),
          ],
          totalPrice: 40.10,
          status: OrderStatus.preparing,
          orderTime: DateTime.now().subtract(const Duration(minutes: 15)),
          deliveryAddress: '2118 Thornridge Cir. Syracuse',
        ),
        Order(
          id: '3',
          orderNumber: '#162434',
          restaurantName: 'ستاربكس',
          restaurantImageUrl: 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=200',
          items: const [
            OrderItem(name: 'لاتيه', quantity: 1, price: 10.30),
          ],
          totalPrice: 10.30,
          status: OrderStatus.pending,
          orderTime: DateTime.now().subtract(const Duration(minutes: 5)),
          deliveryAddress: '2118 Thornridge Cir. Syracuse',
        ),
        // History orders
        Order(
          id: '4',
          orderNumber: '#162430',
          restaurantName: 'بيتزا حارة',
          restaurantImageUrl: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=200',
          items: const [
            OrderItem(name: 'بيتزا مارغريتا', quantity: 2, price: 15.50),
          ],
          totalPrice: 35.25,
          status: OrderStatus.delivered,
          orderTime: DateTime.now().subtract(const Duration(days: 1)),
          deliveryAddress: '2118 Thornridge Cir. Syracuse',
        ),
        Order(
          id: '5',
          orderNumber: '#162431',
          restaurantName: 'ماكدونالدز',
          restaurantImageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=200',
          items: const [
            OrderItem(name: 'بيج ماك', quantity: 2, price: 20.05),
          ],
          totalPrice: 40.10,
          status: OrderStatus.delivered,
          orderTime: DateTime.now().subtract(const Duration(days: 2)),
          deliveryAddress: '2118 Thornridge Cir. Syracuse',
        ),
        Order(
          id: '6',
          orderNumber: '#162429',
          restaurantName: 'ستاربكس',
          restaurantImageUrl: 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=200',
          items: const [
            OrderItem(name: 'لاتيه', quantity: 1, price: 10.30),
          ],
          totalPrice: 10.30,
          status: OrderStatus.cancelled,
          orderTime: DateTime.now().subtract(const Duration(days: 3)),
          deliveryAddress: '2118 Thornridge Cir. Syracuse',
        ),
      ],
    );
  }

  /// Get ongoing orders
  List<Order> get ongoingOrders {
    return orders.where((order) => order.isOngoing).toList();
  }

  /// Get history orders
  List<Order> get historyOrders {
    return orders.where((order) => !order.isOngoing).toList();
  }

  /// Get order by ID
  Order? getOrderById(String id) {
    try {
      return orders.firstWhere((order) => order.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Create a copy with modified fields
  OrderState copyWith({
    List<Order>? orders,
    bool? isLoading,
    String? error,
  }) {
    return OrderState(
      orders: orders ?? this.orders,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Order notifier - manages order state
/// Follows architecture rules: business logic separated from UI
class OrderNotifier extends StateNotifier<OrderState> {
  OrderNotifier() : super(OrderState.initial());

  /// Load orders from backend
  /// In production: Fetch from API
  Future<void> loadOrders() async {
    state = state.copyWith(isLoading: true);
    
    try {
      // TODO: Replace with actual API call
      // final orders = await _orderApiService.getOrders();
      
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Using mock data for now
      final orders = OrderState.initial().orders;
      
      state = state.copyWith(
        orders: orders,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Cancel order
  /// In production: Call API endpoint
  Future<bool> cancelOrder(String orderId) async {
    state = state.copyWith(isLoading: true);
    
    try {
      // TODO: Replace with actual API call
      // await _orderApiService.cancelOrder(orderId);
      
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));
      
      final updatedOrders = state.orders.map((order) {
        if (order.id == orderId) {
          return order.copyWith(status: OrderStatus.cancelled);
        }
        return order;
      }).toList();
      
      state = state.copyWith(
        orders: updatedOrders,
        isLoading: false,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  /// Reorder
  /// In production: Call API endpoint
  Future<bool> reorder(String orderId) async {
    state = state.copyWith(isLoading: true);
    
    try {
      // TODO: Replace with actual API call
      // await _orderApiService.reorder(orderId);
      
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));
      
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  /// Rate order
  /// In production: Call API endpoint
  Future<bool> rateOrder(String orderId, double rating, String? review) async {
    state = state.copyWith(isLoading: true);
    
    try {
      // TODO: Replace with actual API call
      // await _orderApiService.rateOrder(orderId, rating, review);
      
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));
      
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }
}

/// Order provider - exposes order state to UI
final orderProvider = StateNotifierProvider<OrderNotifier, OrderState>((ref) {
  return OrderNotifier();
});
