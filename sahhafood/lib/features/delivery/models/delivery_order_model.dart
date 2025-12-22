/// Local-only delivery order model
/// No serialization - data stays in memory
class DeliveryOrder {
  final String id;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final String restaurantName;
  final String restaurantAddress;
  final double totalAmount;
  final DeliveryOrderStatus status;
  final DateTime orderTime;
  final List<DeliveryOrderItem> items;

  DeliveryOrder({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.restaurantName,
    required this.restaurantAddress,
    required this.totalAmount,
    required this.status,
    required this.orderTime,
    required this.items,
  });

  /// Create a copy with updated fields
  DeliveryOrder copyWith({
    String? id,
    String? customerName,
    String? customerPhone,
    String? customerAddress,
    String? restaurantName,
    String? restaurantAddress,
    double? totalAmount,
    DeliveryOrderStatus? status,
    DateTime? orderTime,
    List<DeliveryOrderItem>? items,
  }) {
    return DeliveryOrder(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerAddress: customerAddress ?? this.customerAddress,
      restaurantName: restaurantName ?? this.restaurantName,
      restaurantAddress: restaurantAddress ?? this.restaurantAddress,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      orderTime: orderTime ?? this.orderTime,
      items: items ?? this.items,
    );
  }
}

/// Order item in delivery
class DeliveryOrderItem {
  final String name;
  final int quantity;
  final double price;

  DeliveryOrderItem({
    required this.name,
    required this.quantity,
    required this.price,
  });
}

/// Delivery order status enum
enum DeliveryOrderStatus {
  pending,
  accepted,
  pickedUp,
  onTheWay,
  delivered,
  cancelled,
}

/// Extension for status display
extension DeliveryOrderStatusExtension on DeliveryOrderStatus {
  String get displayName {
    switch (this) {
      case DeliveryOrderStatus.pending:
        return 'قيد الانتظار';
      case DeliveryOrderStatus.accepted:
        return 'مقبول';
      case DeliveryOrderStatus.pickedUp:
        return 'تم الاستلام';
      case DeliveryOrderStatus.onTheWay:
        return 'في الطريق';
      case DeliveryOrderStatus.delivered:
        return 'تم التوصيل';
      case DeliveryOrderStatus.cancelled:
        return 'ملغي';
    }
  }
}
