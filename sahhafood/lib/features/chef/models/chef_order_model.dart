/// Chef order model - local data only, no serialization
class ChefOrder {
  final String id;
  final String orderNumber;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final List<OrderItem> items;
  final double totalPrice;
  final ChefOrderStatus status;
  final DateTime orderTime;
  final String? deliveryPersonId;
  final String? deliveryPersonName;
  final String? notes;

  ChefOrder({
    required this.id,
    required this.orderNumber,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.items,
    required this.totalPrice,
    required this.status,
    required this.orderTime,
    this.deliveryPersonId,
    this.deliveryPersonName,
    this.notes,
  });

  ChefOrder copyWith({
    String? id,
    String? orderNumber,
    String? customerName,
    String? customerPhone,
    String? customerAddress,
    List<OrderItem>? items,
    double? totalPrice,
    ChefOrderStatus? status,
    DateTime? orderTime,
    String? deliveryPersonId,
    String? deliveryPersonName,
    String? notes,
  }) {
    return ChefOrder(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerAddress: customerAddress ?? this.customerAddress,
      items: items ?? this.items,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      orderTime: orderTime ?? this.orderTime,
      deliveryPersonId: deliveryPersonId ?? this.deliveryPersonId,
      deliveryPersonName: deliveryPersonName ?? this.deliveryPersonName,
      notes: notes ?? this.notes,
    );
  }
}

/// Order item within a chef order
class OrderItem {
  final String foodId;
  final String foodName;
  final int quantity;
  final double price;
  final String? specialInstructions;

  OrderItem({
    required this.foodId,
    required this.foodName,
    required this.quantity,
    required this.price,
    this.specialInstructions,
  });
}

/// Chef order status enum
enum ChefOrderStatus {
  pending,      // New order waiting for chef
  preparing,    // Chef is preparing
  ready,        // Ready for pickup
  outForDelivery, // With delivery person
  completed,    // Delivered
  cancelled,    // Cancelled
}

/// Helper extension for status display
extension ChefOrderStatusExtension on ChefOrderStatus {
  String get displayName {
    switch (this) {
      case ChefOrderStatus.pending:
        return 'قيد الانتظار';
      case ChefOrderStatus.preparing:
        return 'قيد التحضير';
      case ChefOrderStatus.ready:
        return 'جاهز للتوصيل';
      case ChefOrderStatus.outForDelivery:
        return 'في الطريق';
      case ChefOrderStatus.completed:
        return 'مكتمل';
      case ChefOrderStatus.cancelled:
        return 'ملغي';
    }
  }
}
