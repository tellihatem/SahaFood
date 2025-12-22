/// Filter criteria model for home feature
/// Follows architecture rules: immutable, copyWith pattern, backend-ready

enum SortBy {
  popularity,
  rating,
  deliveryTime,
  distance;

  String get displayName {
    switch (this) {
      case SortBy.popularity:
        return 'الأكثر شعبية';
      case SortBy.rating:
        return 'الأعلى تقييماً';
      case SortBy.deliveryTime:
        return 'الأسرع توصيلاً';
      case SortBy.distance:
        return 'الأقرب';
    }
  }
}

class FilterCriteria {
  final double? minPrice;
  final double? maxPrice;
  final double? minRating;
  final int? maxDeliveryTime; // in minutes
  final List<String> cuisineTypes;
  final SortBy sortBy;
  final bool freeDeliveryOnly;

  const FilterCriteria({
    this.minPrice,
    this.maxPrice,
    this.minRating,
    this.maxDeliveryTime,
    this.cuisineTypes = const [],
    this.sortBy = SortBy.popularity,
    this.freeDeliveryOnly = false,
  });

  /// Initial empty filter
  factory FilterCriteria.initial() {
    return const FilterCriteria();
  }

  /// Check if any filter is applied
  bool get hasActiveFilters {
    return minPrice != null ||
        maxPrice != null ||
        minRating != null ||
        maxDeliveryTime != null ||
        cuisineTypes.isNotEmpty ||
        sortBy != SortBy.popularity ||
        freeDeliveryOnly;
  }

  /// Create a copy with modified fields
  FilterCriteria copyWith({
    double? minPrice,
    double? maxPrice,
    double? minRating,
    int? maxDeliveryTime,
    List<String>? cuisineTypes,
    SortBy? sortBy,
    bool? freeDeliveryOnly,
  }) {
    return FilterCriteria(
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      minRating: minRating ?? this.minRating,
      maxDeliveryTime: maxDeliveryTime ?? this.maxDeliveryTime,
      cuisineTypes: cuisineTypes ?? this.cuisineTypes,
      sortBy: sortBy ?? this.sortBy,
      freeDeliveryOnly: freeDeliveryOnly ?? this.freeDeliveryOnly,
    );
  }

  /// Reset all filters
  FilterCriteria reset() {
    return FilterCriteria.initial();
  }

  /// Create from JSON (for API integration)
  factory FilterCriteria.fromJson(Map<String, dynamic> json) {
    return FilterCriteria(
      minPrice: json['min_price'] as double?,
      maxPrice: json['max_price'] as double?,
      minRating: json['min_rating'] as double?,
      maxDeliveryTime: json['max_delivery_time'] as int?,
      cuisineTypes: (json['cuisine_types'] as List?)?.map((e) => e as String).toList() ?? [],
      sortBy: SortBy.values.firstWhere(
        (e) => e.name == json['sort_by'],
        orElse: () => SortBy.popularity,
      ),
      freeDeliveryOnly: json['free_delivery_only'] as bool? ?? false,
    );
  }

  /// Convert to JSON (for API integration)
  Map<String, dynamic> toJson() {
    return {
      'min_price': minPrice,
      'max_price': maxPrice,
      'min_rating': minRating,
      'max_delivery_time': maxDeliveryTime,
      'cuisine_types': cuisineTypes,
      'sort_by': sortBy.name,
      'free_delivery_only': freeDeliveryOnly,
    };
  }
}
