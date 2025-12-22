import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/models.dart';

/// Filter state class
/// Holds the current state of filter functionality
class FilterState {
  final FilterCriteria criteria;
  final bool isLoading;
  final String? error;

  const FilterState({
    required this.criteria,
    this.isLoading = false,
    this.error,
  });

  /// Initial state with empty filter
  factory FilterState.initial() {
    return FilterState(
      criteria: FilterCriteria.initial(),
    );
  }

  /// Create a copy with modified fields
  FilterState copyWith({
    FilterCriteria? criteria,
    bool? isLoading,
    String? error,
  }) {
    return FilterState(
      criteria: criteria ?? this.criteria,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Filter notifier - manages filter state
/// Follows architecture rules: business logic separated from UI
class FilterNotifier extends StateNotifier<FilterState> {
  FilterNotifier() : super(FilterState.initial());

  /// Update filter criteria
  void updateCriteria(FilterCriteria criteria) {
    state = state.copyWith(criteria: criteria);
  }

  /// Update min price
  void updateMinPrice(double? price) {
    final updated = state.criteria.copyWith(minPrice: price);
    state = state.copyWith(criteria: updated);
  }

  /// Update max price
  void updateMaxPrice(double? price) {
    final updated = state.criteria.copyWith(maxPrice: price);
    state = state.copyWith(criteria: updated);
  }

  /// Update min rating
  void updateMinRating(double? rating) {
    final updated = state.criteria.copyWith(minRating: rating);
    state = state.copyWith(criteria: updated);
  }

  /// Update max delivery time
  void updateMaxDeliveryTime(int? time) {
    final updated = state.criteria.copyWith(maxDeliveryTime: time);
    state = state.copyWith(criteria: updated);
  }

  /// Update cuisine types
  void updateCuisineTypes(List<String> types) {
    final updated = state.criteria.copyWith(cuisineTypes: types);
    state = state.copyWith(criteria: updated);
  }

  /// Toggle cuisine type
  void toggleCuisineType(String type) {
    final currentTypes = List<String>.from(state.criteria.cuisineTypes);
    
    if (currentTypes.contains(type)) {
      currentTypes.remove(type);
    } else {
      currentTypes.add(type);
    }
    
    final updated = state.criteria.copyWith(cuisineTypes: currentTypes);
    state = state.copyWith(criteria: updated);
  }

  /// Update sort by
  void updateSortBy(SortBy sortBy) {
    final updated = state.criteria.copyWith(sortBy: sortBy);
    state = state.copyWith(criteria: updated);
  }

  /// Toggle free delivery only
  void toggleFreeDelivery() {
    final updated = state.criteria.copyWith(
      freeDeliveryOnly: !state.criteria.freeDeliveryOnly,
    );
    state = state.copyWith(criteria: updated);
  }

  /// Reset all filters
  void resetFilters() {
    state = FilterState.initial();
  }

  /// Apply filters
  /// In production: Save preferences to backend
  Future<void> applyFilters() async {
    state = state.copyWith(isLoading: true);
    
    try {
      // TODO: Replace with actual API call to save preferences
      // await _filterApiService.savePreferences(state.criteria);
      
      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 300));
      
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Load saved filter preferences
  /// In production: Fetch from API
  Future<void> loadPreferences() async {
    state = state.copyWith(isLoading: true);
    
    try {
      // TODO: Replace with actual API call
      // final criteria = await _filterApiService.getPreferences();
      
      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 300));
      
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}

/// Filter provider - exposes filter state to UI
final filterProvider = StateNotifierProvider<FilterNotifier, FilterState>((ref) {
  return FilterNotifier();
});
