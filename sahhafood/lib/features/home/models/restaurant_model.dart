/// Restaurant model for home feature
/// Follows architecture rules: immutable, copyWith pattern, backend-ready

class Restaurant {
  final String id;
  final String name;
  final double rating;
  final List<String> tags;
  final String deliveryFee;
  final String deliveryTime;
  final String imageUrl;
  final bool isOpen;
  final String? description;
  final String? address;
  final double? distanceKm; // Distance from user in kilometers

  const Restaurant({
    required this.id,
    required this.name,
    required this.rating,
    required this.tags,
    required this.deliveryFee,
    required this.deliveryTime,
    required this.imageUrl,
    this.isOpen = true,
    this.description,
    this.address,
    this.distanceKm,
  });

  /// Check if delivery is free
  bool get isFreeDelivery => deliveryFee == 'مجاني' || deliveryFee.toLowerCase() == 'free';

  /// Create a copy with modified fields
  Restaurant copyWith({
    String? id,
    String? name,
    double? rating,
    List<String>? tags,
    String? deliveryFee,
    String? deliveryTime,
    String? imageUrl,
    bool? isOpen,
    String? description,
    String? address,
    double? distanceKm,
  }) {
    return Restaurant(
      id: id ?? this.id,
      name: name ?? this.name,
      rating: rating ?? this.rating,
      tags: tags ?? this.tags,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      imageUrl: imageUrl ?? this.imageUrl,
      isOpen: isOpen ?? this.isOpen,
      description: description ?? this.description,
      address: address ?? this.address,
      distanceKm: distanceKm ?? this.distanceKm,
    );
  }

  /// Create from JSON (for API integration)
  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'] as String,
      name: json['name'] as String,
      rating: (json['rating'] as num).toDouble(),
      tags: (json['tags'] as List).map((tag) => tag as String).toList(),
      deliveryFee: json['delivery_fee'] as String,
      deliveryTime: json['delivery_time'] as String,
      imageUrl: json['image_url'] as String,
      isOpen: json['is_open'] as bool? ?? true,
      description: json['description'] as String?,
      address: json['address'] as String?,
      distanceKm: json['distance_km'] as double?,
    );
  }

  /// Convert to JSON (for API integration)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'rating': rating,
      'tags': tags,
      'delivery_fee': deliveryFee,
      'delivery_time': deliveryTime,
      'image_url': imageUrl,
      'is_open': isOpen,
      'description': description,
      'address': address,
      'distance_km': distanceKm,
    };
  }
}
