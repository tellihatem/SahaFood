/// Banner model for promotional carousels
/// Follows architecture rules: immutable, copyWith pattern, backend-ready

class PromoBanner {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final String? actionUrl;
  final BannerType type;
  final bool isActive;

  const PromoBanner({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    this.actionUrl,
    this.type = BannerType.promotion,
    this.isActive = true,
  });

  /// Create a copy with modified fields
  PromoBanner copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? imageUrl,
    String? actionUrl,
    BannerType? type,
    bool? isActive,
  }) {
    return PromoBanner(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      imageUrl: imageUrl ?? this.imageUrl,
      actionUrl: actionUrl ?? this.actionUrl,
      type: type ?? this.type,
      isActive: isActive ?? this.isActive,
    );
  }

  /// Create from JSON (for API integration)
  factory PromoBanner.fromJson(Map<String, dynamic> json) {
    return PromoBanner(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      imageUrl: json['image_url'] as String,
      actionUrl: json['action_url'] as String?,
      type: BannerType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => BannerType.promotion,
      ),
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  /// Convert to JSON (for API integration)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'image_url': imageUrl,
      'action_url': actionUrl,
      'type': type.name,
      'is_active': isActive,
    };
  }
}

/// Banner type enum
enum BannerType {
  promotion,
  newRestaurant,
  discount,
  announcement,
}
