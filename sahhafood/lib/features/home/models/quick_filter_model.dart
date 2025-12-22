/// Quick filter model for home screen filtering
/// Follows architecture rules: immutable, simple local model

class QuickFilter {
  final String id;
  final String label;
  final QuickFilterType type;
  final bool isSelected;

  const QuickFilter({
    required this.id,
    required this.label,
    required this.type,
    this.isSelected = false,
  });

  /// Create a copy with modified fields
  QuickFilter copyWith({
    String? id,
    String? label,
    QuickFilterType? type,
    bool? isSelected,
  }) {
    return QuickFilter(
      id: id ?? this.id,
      label: label ?? this.label,
      type: type ?? this.type,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

/// Quick filter type enum
enum QuickFilterType {
  fastDelivery,
  topRated,
  freeDelivery,
  nearYou,
  openNow,
  newRestaurants,
}

extension QuickFilterTypeExtension on QuickFilterType {
  String get displayName {
    switch (this) {
      case QuickFilterType.fastDelivery:
        return 'توصيل سريع';
      case QuickFilterType.topRated:
        return 'الأعلى تقييماً';
      case QuickFilterType.freeDelivery:
        return 'توصيل مجاني';
      case QuickFilterType.nearYou:
        return 'قريب منك';
      case QuickFilterType.openNow:
        return 'مفتوح الآن';
      case QuickFilterType.newRestaurants:
        return 'مطاعم جديدة';
    }
  }
}
