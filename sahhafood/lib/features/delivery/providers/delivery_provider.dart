import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/models.dart';

/// Delivery state provider using Riverpod
/// Manages local state for delivery orders and person info
class DeliveryState {
  final DeliveryPerson? deliveryPerson;
  final List<DeliveryOrder> activeOrders;
  final List<DeliveryOrder> completedOrders;
  final bool isLoading;
  final String? error;

  DeliveryState({
    this.deliveryPerson,
    this.activeOrders = const [],
    this.completedOrders = const [],
    this.isLoading = false,
    this.error,
  });

  DeliveryState copyWith({
    DeliveryPerson? deliveryPerson,
    List<DeliveryOrder>? activeOrders,
    List<DeliveryOrder>? completedOrders,
    bool? isLoading,
    String? error,
  }) {
    return DeliveryState(
      deliveryPerson: deliveryPerson ?? this.deliveryPerson,
      activeOrders: activeOrders ?? this.activeOrders,
      completedOrders: completedOrders ?? this.completedOrders,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

/// Delivery state notifier
class DeliveryNotifier extends StateNotifier<DeliveryState> {
  DeliveryNotifier() : super(DeliveryState()) {
    _initializeMockData();
  }

  /// Initialize with mock data (local only)
  void _initializeMockData() {
    final mockPerson = DeliveryPerson(
      id: '1',
      name: 'أحمد محمد',
      phone: '+213612345678',
      vehicleType: 'دراجة نارية',
      vehicleNumber: 'ABC-123',
      rating: 4.8,
      totalDeliveries: 156,
      totalEarnings: 12500.0,
      isAvailable: true,
    );

    final mockOrders = [
      DeliveryOrder(
        id: '1',
        customerName: 'سارة أحمد',
        customerPhone: '+213698765432',
        customerAddress: 'شارع الاستقلال، الجزائر',
        restaurantName: 'مطعم الأصالة',
        restaurantAddress: 'شارع ديدوش مراد، الجزائر',
        totalAmount: 1250.0,
        status: DeliveryOrderStatus.accepted,
        orderTime: DateTime.now().subtract(const Duration(minutes: 10)),
        items: [
          DeliveryOrderItem(name: 'برجر لحم', quantity: 2, price: 500.0),
          DeliveryOrderItem(name: 'بطاطس مقلية', quantity: 1, price: 250.0),
        ],
      ),
      DeliveryOrder(
        id: '2',
        customerName: 'محمد علي',
        customerPhone: '+213656789012',
        customerAddress: 'حي بوزريعة، الجزائر',
        restaurantName: 'مطعم الذوق الرفيع',
        restaurantAddress: 'شارع العربي بن مهيدي، الجزائر',
        totalAmount: 850.0,
        status: DeliveryOrderStatus.pending,
        orderTime: DateTime.now().subtract(const Duration(minutes: 5)),
        items: [
          DeliveryOrderItem(name: 'بيتزا مارغريتا', quantity: 1, price: 850.0),
        ],
      ),
    ];

    state = state.copyWith(
      deliveryPerson: mockPerson,
      activeOrders: mockOrders,
    );
  }

  /// Accept an order
  void acceptOrder(String orderId) {
    final updatedOrders = state.activeOrders.map((order) {
      if (order.id == orderId) {
        return order.copyWith(status: DeliveryOrderStatus.accepted);
      }
      return order;
    }).toList();

    state = state.copyWith(activeOrders: updatedOrders);
  }

  /// Mark order as picked up
  void markAsPickedUp(String orderId) {
    final updatedOrders = state.activeOrders.map((order) {
      if (order.id == orderId) {
        return order.copyWith(status: DeliveryOrderStatus.pickedUp);
      }
      return order;
    }).toList();

    state = state.copyWith(activeOrders: updatedOrders);
  }

  /// Mark order as on the way
  void markAsOnTheWay(String orderId) {
    final updatedOrders = state.activeOrders.map((order) {
      if (order.id == orderId) {
        return order.copyWith(status: DeliveryOrderStatus.onTheWay);
      }
      return order;
    }).toList();

    state = state.copyWith(activeOrders: updatedOrders);
  }

  /// Complete delivery
  void completeDelivery(String orderId) {
    final order = state.activeOrders.firstWhere((o) => o.id == orderId);
    final completedOrder = order.copyWith(status: DeliveryOrderStatus.delivered);

    final updatedActiveOrders = state.activeOrders.where((o) => o.id != orderId).toList();
    final updatedCompletedOrders = [...state.completedOrders, completedOrder];

    state = state.copyWith(
      activeOrders: updatedActiveOrders,
      completedOrders: updatedCompletedOrders,
    );
  }

  /// Toggle availability
  void toggleAvailability() {
    if (state.deliveryPerson != null) {
      final updatedPerson = state.deliveryPerson!.copyWith(
        isAvailable: !state.deliveryPerson!.isAvailable,
      );
      state = state.copyWith(deliveryPerson: updatedPerson);
    }
  }
}

/// Provider for delivery state
final deliveryProvider = StateNotifierProvider<DeliveryNotifier, DeliveryState>((ref) {
  return DeliveryNotifier();
});
