import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/models.dart';

/// Category state class
/// Holds the current state of food categories
class CategoryState {
  final List<FoodCategory> categories;
  final bool isLoading;
  final String? error;

  const CategoryState({
    required this.categories,
    this.isLoading = false,
    this.error,
  });

  /// Initial state with mock categories
  factory CategoryState.initial() {
    return const CategoryState(
      categories: [
        FoodCategory(
          id: '1',
          name: 'بيتزا',
          imageUrl: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=100',
          color: Color(0xFFFFE5E5),
        ),
        FoodCategory(
          id: '2',
          name: 'برجر',
          imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=100',
          color: Color(0xFFE5F5FF),
        ),
        FoodCategory(
          id: '3',
          name: 'دجاج',
          imageUrl: 'https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?w=100',
          color: Color(0xFFFFE5F0),
        ),
        FoodCategory(
          id: '4',
          name: 'سوشي',
          imageUrl: 'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=100',
          color: Color(0xFFE5FFE5),
        ),
        FoodCategory(
          id: '5',
          name: 'حلويات',
          imageUrl: 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=100',
          color: Color(0xFFFFF5E5),
        ),
      ],
    );
  }

  /// Create a copy with modified fields
  CategoryState copyWith({
    List<FoodCategory>? categories,
    bool? isLoading,
    String? error,
  }) {
    return CategoryState(
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Category notifier - manages category state
/// Follows architecture rules: business logic separated from UI
class CategoryNotifier extends StateNotifier<CategoryState> {
  CategoryNotifier() : super(CategoryState.initial());

  /// Load categories from backend
  /// In production: Fetch from API
  Future<void> loadCategories() async {
    state = state.copyWith(isLoading: true);
    
    try {
      // TODO: Replace with actual API call
      // final categories = await _categoryApiService.getCategories();
      
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Using mock data for now
      final categories = CategoryState.initial().categories;
      
      state = state.copyWith(
        categories: categories,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}

/// Category provider - exposes category state to UI
final categoryProvider = StateNotifierProvider<CategoryNotifier, CategoryState>((ref) {
  return CategoryNotifier();
});
