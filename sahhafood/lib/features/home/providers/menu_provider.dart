import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/models.dart';

/// Menu state class
/// Holds the current state of menu items
class MenuState {
  final List<MenuItem> items;
  final bool isLoading;
  final String? error;

  const MenuState({
    required this.items,
    this.isLoading = false,
    this.error,
  });

  /// Initial state with mock menu items
  factory MenuState.initial() {
    return const MenuState(
      items: [
        MenuItem(
          id: '1',
          name: 'بيتزا مارغريتا',
          description: 'بيتزا إيطالية كلاسيكية مع صلصة الطماطم والجبن',
          price: 45.00,
          imageUrl: 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=400',
          category: 'بيتزا',
          restaurantId: '1',
          rating: 4.5,
          reviewCount: 120,
        ),
        MenuItem(
          id: '2',
          name: 'برجر كلاسيك',
          description: 'برجر لحم بقري مع خس وطماطم وصوص خاص',
          price: 35.00,
          imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400',
          category: 'برجر',
          restaurantId: '2',
          rating: 4.7,
          reviewCount: 200,
        ),
        MenuItem(
          id: '3',
          name: 'دجاج مشوي',
          description: 'دجاج مشوي بالأعشاب والتوابل',
          price: 40.00,
          imageUrl: 'https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?w=400',
          category: 'دجاج',
          restaurantId: '1',
          rating: 4.6,
          reviewCount: 85,
        ),
        MenuItem(
          id: '4',
          name: 'سوشي رول',
          description: 'سوشي طازج مع سمك السلمون',
          price: 55.00,
          imageUrl: 'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=400',
          category: 'سوشي',
          restaurantId: '5',
          rating: 4.9,
          reviewCount: 150,
        ),
        MenuItem(
          id: '5',
          name: 'شاورما دجاج',
          description: 'شاورما دجاج مع الثوم والمخلل',
          price: 25.00,
          imageUrl: 'https://images.unsplash.com/photo-1529006557810-274b9b2fc783?w=400',
          category: 'شاورما',
          restaurantId: '6',
          rating: 4.4,
          reviewCount: 180,
        ),
      ],
    );
  }

  /// Get menu items by restaurant ID
  List<MenuItem> getItemsByRestaurantId(String restaurantId) {
    return items.where((item) => item.restaurantId == restaurantId).toList();
  }

  /// Get menu item by ID
  MenuItem? getItemById(String id) {
    try {
      return items.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get menu items by category
  List<MenuItem> getItemsByCategory(String category) {
    return items.where((item) => item.category == category).toList();
  }

  /// Create a copy with modified fields
  MenuState copyWith({
    List<MenuItem>? items,
    bool? isLoading,
    String? error,
  }) {
    return MenuState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Menu notifier - manages menu state
/// Follows architecture rules: business logic separated from UI
class MenuNotifier extends StateNotifier<MenuState> {
  MenuNotifier() : super(MenuState.initial());

  /// Load menu items from backend
  /// In production: Fetch from API
  Future<void> loadMenuItems() async {
    state = state.copyWith(isLoading: true);
    
    try {
      // TODO: Replace with actual API call
      // final items = await _menuApiService.getMenuItems();
      
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Using mock data for now
      final items = MenuState.initial().items;
      
      state = state.copyWith(
        items: items,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Load menu items by restaurant
  /// In production: Call API endpoint
  Future<void> loadMenuByRestaurant(String restaurantId) async {
    state = state.copyWith(isLoading: true);
    
    try {
      // TODO: Replace with actual API call
      // final items = await _menuApiService.getMenuByRestaurant(restaurantId);
      
      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}

/// Menu provider - exposes menu state to UI
final menuProvider = StateNotifierProvider<MenuNotifier, MenuState>((ref) {
  return MenuNotifier();
});
