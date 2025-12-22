import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/models.dart';

/// Restaurant state class
/// Holds the current state of restaurants
class RestaurantState {
  final List<Restaurant> restaurants;
  final bool isLoading;
  final String? error;

  const RestaurantState({
    required this.restaurants,
    this.isLoading = false,
    this.error,
  });

  /// Initial state with mock restaurants
  factory RestaurantState.initial() {
    return RestaurantState(
      restaurants: [
        const Restaurant(
          id: '1',
          name: 'مطعم روز جاردن',
          rating: 4.7,
          tags: ['برجر', 'دجاج', 'أرز', 'أجنحة'],
          deliveryFee: 'مجاني',
          deliveryTime: '20 دقيقة',
          imageUrl: 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=400',
          distanceKm: 1.2,
        ),
        const Restaurant(
          id: '2',
          name: 'مطعم البيك',
          rating: 4.9,
          tags: ['دجاج', 'برجر', 'بطاطس', 'مشروبات'],
          deliveryFee: '\$2',
          deliveryTime: '15 دقيقة',
          imageUrl: 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=400',
          distanceKm: 0.8,
        ),
        const Restaurant(
          id: '3',
          name: 'مطعم الطازج',
          rating: 4.5,
          tags: ['سلطات', 'صحي', 'عصائر', 'فواكه'],
          deliveryFee: 'مجاني',
          deliveryTime: '25 دقيقة',
          imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400',
          distanceKm: 2.5,
        ),
        const Restaurant(
          id: '4',
          name: 'بيتزا هت',
          rating: 4.6,
          tags: ['بيتزا', 'باستا', 'مقبلات', 'حلويات'],
          deliveryFee: '\$3',
          deliveryTime: '30 دقيقة',
          imageUrl: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=400',
          distanceKm: 3.1,
        ),
        const Restaurant(
          id: '5',
          name: 'مطعم السوشي',
          rating: 4.8,
          tags: ['سوشي', 'ياباني', 'مأكولات بحرية', 'نودلز'],
          deliveryFee: '\$5',
          deliveryTime: '35 دقيقة',
          imageUrl: 'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=400',
          distanceKm: 4.2,
        ),
        const Restaurant(
          id: '6',
          name: 'مطعم الشاورما',
          rating: 4.4,
          tags: ['شاورما', 'فلافل', 'حمص', 'فتوش'],
          deliveryFee: 'مجاني',
          deliveryTime: '18 دقيقة',
          imageUrl: 'https://images.unsplash.com/photo-1529006557810-274b9b2fc783?w=400',
          distanceKm: 1.5,
        ),
      ],
    );
  }

  /// Get restaurant by ID
  Restaurant? getRestaurantById(String id) {
    try {
      return restaurants.firstWhere((r) => r.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Create a copy with modified fields
  RestaurantState copyWith({
    List<Restaurant>? restaurants,
    bool? isLoading,
    String? error,
  }) {
    return RestaurantState(
      restaurants: restaurants ?? this.restaurants,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Restaurant notifier - manages restaurant state
/// Follows architecture rules: business logic separated from UI
class RestaurantNotifier extends StateNotifier<RestaurantState> {
  RestaurantNotifier() : super(RestaurantState.initial());

  /// Load restaurants from backend
  /// In production: Fetch from API
  Future<void> loadRestaurants() async {
    state = state.copyWith(isLoading: true);
    
    try {
      // TODO: Replace with actual API call
      // final restaurants = await _restaurantApiService.getRestaurants();
      
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Using mock data for now
      final restaurants = RestaurantState.initial().restaurants;
      
      state = state.copyWith(
        restaurants: restaurants,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Search restaurants by query
  /// In production: Call API endpoint
  List<Restaurant> searchRestaurants(String query) {
    if (query.isEmpty) return state.restaurants;
    
    final lowerQuery = query.toLowerCase();
    return state.restaurants.where((restaurant) {
      return restaurant.name.toLowerCase().contains(lowerQuery) ||
          restaurant.tags.any((tag) => tag.toLowerCase().contains(lowerQuery));
    }).toList();
  }

  /// Filter restaurants by criteria
  /// In production: Call API endpoint with filters
  List<Restaurant> filterRestaurants(FilterCriteria criteria) {
    var filtered = List<Restaurant>.from(state.restaurants);

    // Filter by rating
    if (criteria.minRating != null) {
      filtered = filtered.where((r) => r.rating >= criteria.minRating!).toList();
    }

    // Filter by free delivery
    if (criteria.freeDeliveryOnly) {
      filtered = filtered.where((r) => r.isFreeDelivery).toList();
    }

    // Filter by cuisine types
    if (criteria.cuisineTypes.isNotEmpty) {
      filtered = filtered.where((r) {
        return r.tags.any((tag) => criteria.cuisineTypes.contains(tag));
      }).toList();
    }

    // Sort results
    switch (criteria.sortBy) {
      case SortBy.rating:
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case SortBy.deliveryTime:
        // Simple sort by delivery time string (not perfect but works for mock data)
        filtered.sort((a, b) => a.deliveryTime.compareTo(b.deliveryTime));
        break;
      case SortBy.popularity:
      case SortBy.distance:
        // Keep default order for now
        break;
    }

    return filtered;
  }

  /// Filter restaurants by quick filter type
  /// In production: Call API endpoint with filter type
  List<Restaurant> filterByQuickFilter(QuickFilterType? filterType) {
    if (filterType == null) return state.restaurants;

    var filtered = List<Restaurant>.from(state.restaurants);

    switch (filterType) {
      case QuickFilterType.fastDelivery:
        // Filter restaurants with delivery time <= 20 minutes
        filtered = filtered.where((r) {
          final timeStr = r.deliveryTime.replaceAll(RegExp(r'[^0-9]'), '');
          final time = int.tryParse(timeStr) ?? 999;
          return time <= 20;
        }).toList();
        break;
      case QuickFilterType.topRated:
        // Filter restaurants with rating >= 4.5
        filtered = filtered.where((r) => r.rating >= 4.5).toList();
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case QuickFilterType.freeDelivery:
        // Filter restaurants with free delivery
        filtered = filtered.where((r) => r.isFreeDelivery).toList();
        break;
      case QuickFilterType.nearYou:
        // Filter restaurants within 2km
        filtered = filtered.where((r) => (r.distanceKm ?? 999) <= 2.0).toList();
        filtered.sort((a, b) => (a.distanceKm ?? 999).compareTo(b.distanceKm ?? 999));
        break;
      case QuickFilterType.openNow:
        // Filter open restaurants
        filtered = filtered.where((r) => r.isOpen).toList();
        break;
      case QuickFilterType.newRestaurants:
        // For mock data, just reverse the list to simulate new restaurants
        filtered = filtered.reversed.toList();
        break;
    }

    return filtered;
  }
}

/// Restaurant provider - exposes restaurant state to UI
final restaurantProvider = StateNotifierProvider<RestaurantNotifier, RestaurantState>((ref) {
  return RestaurantNotifier();
});
