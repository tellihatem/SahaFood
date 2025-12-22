/// Cart item model representing a single item in the shopping cart
/// Follows architecture rules: immutable, copyWith pattern, no backend logic
class CartItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final int quantity;
  final String imageUrl;

  const CartItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });

  /// Calculate total price for this item
  double get totalPrice => price * quantity;

  /// Create a copy with modified fields
  CartItem copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    int? quantity,
    String? imageUrl,
  }) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  /// Create from JSON (for API integration)
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] as int,
      imageUrl: json['image_url'] as String,
    );
  }

  /// Convert to JSON (for API integration)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'quantity': quantity,
      'image_url': imageUrl,
    };
  }
}
