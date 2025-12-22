/// Quick filter provider for home screen
/// Follows architecture rules: Riverpod, immutable state, local data

import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/models.dart';

/// Quick filter state class
class QuickFilterState {
  final List<QuickFilter> filters;
  final QuickFilterType? selectedFilter;

  const QuickFilterState({
    this.filters = const [],
    this.selectedFilter,
  });

  QuickFilterState copyWith({
    List<QuickFilter>? filters,
    QuickFilterType? selectedFilter,
  }) {
    return QuickFilterState(
      filters: filters ?? this.filters,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }

  /// Get selected filter
  QuickFilter? get selected => filters.firstWhere(
        (f) => f.isSelected,
        orElse: () => filters.first,
      );
}

/// Quick filter notifier
class QuickFilterNotifier extends StateNotifier<QuickFilterState> {
  QuickFilterNotifier() : super(const QuickFilterState()) {
    _initializeFilters();
  }

  /// Initialize filters
  void _initializeFilters() {
    final filters = [
      const QuickFilter(
        id: 'fast_delivery',
        label: 'توصيل سريع',
        type: QuickFilterType.fastDelivery,
      ),
      const QuickFilter(
        id: 'top_rated',
        label: 'الأعلى تقييماً',
        type: QuickFilterType.topRated,
      ),
      const QuickFilter(
        id: 'free_delivery',
        label: 'توصيل مجاني',
        type: QuickFilterType.freeDelivery,
      ),
      const QuickFilter(
        id: 'near_you',
        label: 'قريب منك',
        type: QuickFilterType.nearYou,
      ),
      const QuickFilter(
        id: 'open_now',
        label: 'مفتوح الآن',
        type: QuickFilterType.openNow,
      ),
      const QuickFilter(
        id: 'new_restaurants',
        label: 'مطاعم جديدة',
        type: QuickFilterType.newRestaurants,
      ),
    ];

    state = state.copyWith(filters: filters);
  }

  /// Toggle filter selection
  void toggleFilter(QuickFilterType type) {
    final updatedFilters = state.filters.map((filter) {
      if (filter.type == type) {
        return filter.copyWith(isSelected: !filter.isSelected);
      }
      return filter.copyWith(isSelected: false);
    }).toList();

    state = state.copyWith(
      filters: updatedFilters,
      selectedFilter: updatedFilters.any((f) => f.isSelected) ? type : null,
    );
  }

  /// Clear all filters
  void clearFilters() {
    final updatedFilters = state.filters.map((filter) {
      return filter.copyWith(isSelected: false);
    }).toList();

    state = state.copyWith(
      filters: updatedFilters,
      selectedFilter: null,
    );
  }
}

/// Quick filter provider
final quickFilterProvider =
    StateNotifierProvider<QuickFilterNotifier, QuickFilterState>((ref) {
  return QuickFilterNotifier();
});
