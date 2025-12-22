/// Food item model - local data only, no serialization
class FoodItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final FoodCategory category;
  final String imageUrl;
  final bool isAvailable;
  final int preparationTime; // in minutes
  final double rating;
  final int reviewsCount;
  final List<String> ingredients;

  FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
    this.isAvailable = true,
    this.preparationTime = 30,
    this.rating = 0.0,
    this.reviewsCount = 0,
    this.ingredients = const [],
  });

  FoodItem copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    FoodCategory? category,
    String? imageUrl,
    bool? isAvailable,
    int? preparationTime,
    double? rating,
    int? reviewsCount,
    List<String>? ingredients,
  }) {
    return FoodItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      isAvailable: isAvailable ?? this.isAvailable,
      preparationTime: preparationTime ?? this.preparationTime,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      ingredients: ingredients ?? this.ingredients,
    );
  }
}

/// Food category enum
enum FoodCategory {
  all,
  breakfast,
  lunch,
  dinner,
  dessert,
  drinks,
  appetizers,
}

/// Helper extension for category display
extension FoodCategoryExtension on FoodCategory {
  String get displayName {
    switch (this) {
      case FoodCategory.all:
        return 'الكل';
      case FoodCategory.breakfast:
        return 'فطور';
      case FoodCategory.lunch:
        return 'غداء';
      case FoodCategory.dinner:
        return 'عشاء';
      case FoodCategory.dessert:
        return 'حلويات';
      case FoodCategory.drinks:
        return 'مشروبات';
      case FoodCategory.appetizers:
        return 'مقبلات';
    }
  }
}
