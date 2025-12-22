/// Favorite item model
/// Follows architecture rules: immutable, copyWith pattern, local-only

enum FavoriteType {
  restaurant,
  menuItem,
}

class FavoriteItem {
  final String id;
  final String itemId; // Restaurant or MenuItem ID
  final FavoriteType type;
  final DateTime addedAt;

  const FavoriteItem({
    required this.id,
    required this.itemId,
    required this.type,
    required this.addedAt,
  });

  /// Create a copy with modified fields
  FavoriteItem copyWith({
    String? id,
    String? itemId,
    FavoriteType? type,
    DateTime? addedAt,
  }) {
    return FavoriteItem(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      type: type ?? this.type,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  /// Create from JSON (for local storage)
  factory FavoriteItem.fromJson(Map<String, dynamic> json) {
    return FavoriteItem(
      id: json['id'] as String,
      itemId: json['item_id'] as String,
      type: FavoriteType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => FavoriteType.restaurant,
      ),
      addedAt: DateTime.parse(json['added_at'] as String),
    );
  }

  /// Convert to JSON (for local storage)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'item_id': itemId,
      'type': type.name,
      'added_at': addedAt.toIso8601String(),
    };
  }
}
