import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';

/// Food state containing menu items
class FoodState {
  final List<FoodItem> items;
  final FoodCategory selectedCategory;

  FoodState({
    this.items = const [],
    this.selectedCategory = FoodCategory.all,
  });

  FoodState copyWith({
    List<FoodItem>? items,
    FoodCategory? selectedCategory,
  }) {
    return FoodState(
      items: items ?? this.items,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }

  /// Get filtered items by selected category
  List<FoodItem> get filteredItems {
    if (selectedCategory == FoodCategory.all) {
      return items;
    }
    return items.where((item) => item.category == selectedCategory).toList();
  }
}

/// Food provider with state management
class FoodNotifier extends StateNotifier<FoodState> {
  FoodNotifier() : super(FoodState()) {
    _initializeMockData();
  }

  /// Initialize with mock data for development
  void _initializeMockData() {
    final mockItems = [
      FoodItem(
        id: '1',
        name: 'برجر لحم',
        description: 'برجر لحم بقري مشوي مع خضروات طازجة',
        price: 1200.0,
        category: FoodCategory.lunch,
        imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400',
        isAvailable: true,
        preparationTime: 20,
        rating: 4.7,
        reviewsCount: 45,
        ingredients: ['لحم بقري', 'خبز', 'خس', 'طماطم', 'جبن'],
      ),
      FoodItem(
        id: '2',
        name: 'كسكس بالدجاج',
        description: 'كسكس تقليدي مع دجاج وخضروات',
        price: 1500.0,
        category: FoodCategory.lunch,
        imageUrl: 'https://images.unsplash.com/photo-1589302168068-964664d93dc0?w=400',
        isAvailable: true,
        preparationTime: 45,
        rating: 4.9,
        reviewsCount: 78,
        ingredients: ['سميد', 'دجاج', 'خضروات', 'توابل'],
      ),
      FoodItem(
        id: '3',
        name: 'بيتزا مارغريتا',
        description: 'بيتزا إيطالية كلاسيكية مع الريحان والجبن',
        price: 1800.0,
        category: FoodCategory.dinner,
        imageUrl: 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=400',
        isAvailable: true,
        preparationTime: 25,
        rating: 4.6,
        reviewsCount: 62,
        ingredients: ['عجينة بيتزا', 'صلصة طماطم', 'موتزاريلا', 'ريحان'],
      ),
      FoodItem(
        id: '4',
        name: 'شكشوكة',
        description: 'طبق تقليدي من البيض والطماطم',
        price: 800.0,
        category: FoodCategory.breakfast,
        imageUrl: 'https://images.unsplash.com/photo-1587048572686-2af9e03f5f6b?w=400',
        isAvailable: true,
        preparationTime: 15,
        rating: 4.8,
        reviewsCount: 34,
        ingredients: ['بيض', 'طماطم', 'فلفل', 'بصل'],
      ),
      FoodItem(
        id: '5',
        name: 'حلوى البقلاوة',
        description: 'حلوى شرقية بالمكسرات والعسل',
        price: 600.0,
        category: FoodCategory.dessert,
        imageUrl: 'https://images.unsplash.com/photo-1519676867240-f03562e64548?w=400',
        isAvailable: true,
        preparationTime: 10,
        rating: 4.9,
        reviewsCount: 89,
        ingredients: ['عجين فيلو', 'فستق', 'عسل'],
      ),
      FoodItem(
        id: '6',
        name: 'عصير برتقال طازج',
        description: 'عصير برتقال طبيعي 100%',
        price: 300.0,
        category: FoodCategory.drinks,
        imageUrl: 'https://images.unsplash.com/photo-1600271886742-f049cd451bba?w=400',
        isAvailable: true,
        preparationTime: 5,
        rating: 4.5,
        reviewsCount: 23,
        ingredients: ['برتقال طازج'],
      ),
    ];

    state = state.copyWith(items: mockItems);
  }

  /// Set selected category for filtering
  void setCategory(FoodCategory category) {
    state = state.copyWith(selectedCategory: category);
  }

  /// Add new food item
  void addItem(FoodItem item) {
    state = state.copyWith(items: [...state.items, item]);
  }

  /// Update existing food item
  void updateItem(String itemId, FoodItem updatedItem) {
    final updatedItems = state.items.map((item) {
      return item.id == itemId ? updatedItem : item;
    }).toList();

    state = state.copyWith(items: updatedItems);
  }

  /// Delete food item
  void deleteItem(String itemId) {
    final updatedItems = state.items.where((item) => item.id != itemId).toList();
    state = state.copyWith(items: updatedItems);
  }

  /// Toggle item availability
  void toggleAvailability(String itemId) {
    final updatedItems = state.items.map((item) {
      if (item.id == itemId) {
        return item.copyWith(isAvailable: !item.isAvailable);
      }
      return item;
    }).toList();

    state = state.copyWith(items: updatedItems);
  }
}

/// Provider instance
final foodProvider = StateNotifierProvider<FoodNotifier, FoodState>((ref) {
  return FoodNotifier();
});
