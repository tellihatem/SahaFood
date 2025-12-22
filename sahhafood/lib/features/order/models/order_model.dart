/// Order model for customer orders
/// Follows architecture rules: immutable, copyWith pattern, backend-ready

enum OrderStatus {
  pending,
  confirmed,
  preparing,
  onTheWay,
  delivered,
  cancelled;

  String get displayName {
    switch (this) {
      case OrderStatus.pending:
        return 'قيد الانتظار';
      case OrderStatus.confirmed:
        return 'مؤكد';
      case OrderStatus.preparing:
        return 'قيد التحضير';
      case OrderStatus.onTheWay:
        return 'في الطريق';
      case OrderStatus.delivered:
        return 'تم التوصيل';
      case OrderStatus.cancelled:
        return 'ملغي';
    }
  }
}

class OrderItem {
  final String name;
  final int quantity;
  final double price;

  const OrderItem({
    required this.name,
    required this.quantity,
    required this.price,
  });

  double get totalPrice => price * quantity;

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      name: json['name'] as String,
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'quantity': quantity,
      'price': price,
    };
  }
}

class Order {
  final String id;
  final String orderNumber;
  final String restaurantName;
  final String restaurantImageUrl;
  final List<OrderItem> items;
  final double totalPrice;
  final OrderStatus status;
  final DateTime orderTime;
  final String? deliveryAddress;
  final String? driverName;
  final String? driverPhone;
  final String? driverImageUrl;

  const Order({
    required this.id,
    required this.orderNumber,
    required this.restaurantName,
    required this.restaurantImageUrl,
    required this.items,
    required this.totalPrice,
    required this.status,
    required this.orderTime,
    this.deliveryAddress,
    this.driverName,
    this.driverPhone,
    this.driverImageUrl,
  });

  /// Check if order is ongoing
  bool get isOngoing {
    return status == OrderStatus.pending ||
        status == OrderStatus.confirmed ||
        status == OrderStatus.preparing ||
        status == OrderStatus.onTheWay;
  }

  /// Get total items count
  int get totalItems {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  /// Create a copy with modified fields
  Order copyWith({
    String? id,
    String? orderNumber,
    String? restaurantName,
    String? restaurantImageUrl,
    List<OrderItem>? items,
    double? totalPrice,
    OrderStatus? status,
    DateTime? orderTime,
    String? deliveryAddress,
    String? driverName,
    String? driverPhone,
    String? driverImageUrl,
  }) {
    return Order(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      restaurantName: restaurantName ?? this.restaurantName,
      restaurantImageUrl: restaurantImageUrl ?? this.restaurantImageUrl,
      items: items ?? this.items,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      orderTime: orderTime ?? this.orderTime,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      driverName: driverName ?? this.driverName,
      driverPhone: driverPhone ?? this.driverPhone,
      driverImageUrl: driverImageUrl ?? this.driverImageUrl,
    );
  }

  /// Create from JSON (for API integration)
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      orderNumber: json['order_number'] as String,
      restaurantName: json['restaurant_name'] as String,
      restaurantImageUrl: json['restaurant_image_url'] as String,
      items: (json['items'] as List)
          .map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      totalPrice: (json['total_price'] as num).toDouble(),
      status: OrderStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => OrderStatus.pending,
      ),
      orderTime: DateTime.parse(json['order_time'] as String),
      deliveryAddress: json['delivery_address'] as String?,
      driverName: json['driver_name'] as String?,
      driverPhone: json['driver_phone'] as String?,
      driverImageUrl: json['driver_image_url'] as String?,
    );
  }

  /// Convert to JSON (for API integration)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_number': orderNumber,
      'restaurant_name': restaurantName,
      'restaurant_image_url': restaurantImageUrl,
      'items': items.map((item) => item.toJson()).toList(),
      'total_price': totalPrice,
      'status': status.name,
      'order_time': orderTime.toIso8601String(),
      'delivery_address': deliveryAddress,
      'driver_name': driverName,
      'driver_phone': driverPhone,
      'driver_image_url': driverImageUrl,
    };
  }
}
