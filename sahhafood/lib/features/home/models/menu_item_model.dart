/// Menu item model for home feature (client version)
/// Follows architecture rules: immutable, copyWith pattern, backend-ready

class MenuItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final String restaurantId;
  final double rating;
  final int reviewCount;
  final bool isAvailable;

  const MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.restaurantId,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isAvailable = true,
  });

  /// Create a copy with modified fields
  MenuItem copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    String? category,
    String? restaurantId,
    double? rating,
    int? reviewCount,
    bool? isAvailable,
  }) {
    return MenuItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      restaurantId: restaurantId ?? this.restaurantId,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }

  /// Create from JSON (for API integration)
  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['image_url'] as String,
      category: json['category'] as String,
      restaurantId: json['restaurant_id'] as String,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['review_count'] as int? ?? 0,
      isAvailable: json['is_available'] as bool? ?? true,
    );
  }

  /// Convert to JSON (for API integration)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image_url': imageUrl,
      'category': category,
      'restaurant_id': restaurantId,
      'rating': rating,
      'review_count': reviewCount,
      'is_available': isAvailable,
    };
  }
}
