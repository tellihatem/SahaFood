import 'package:flutter/material.dart';

/// Food category model for home feature
/// Follows architecture rules: immutable, copyWith pattern, backend-ready

class FoodCategory {
  final String id;
  final String name;
  final String imageUrl;
  final Color color;

  const FoodCategory({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.color,
  });

  /// Create a copy with modified fields
  FoodCategory copyWith({
    String? id,
    String? name,
    String? imageUrl,
    Color? color,
  }) {
    return FoodCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      color: color ?? this.color,
    );
  }

  /// Create from JSON (for API integration)
  factory FoodCategory.fromJson(Map<String, dynamic> json) {
    return FoodCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['image_url'] as String,
      color: Color(json['color'] as int),
    );
  }

  /// Convert to JSON (for API integration)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image_url': imageUrl,
      'color': color.value,
    };
  }
}
