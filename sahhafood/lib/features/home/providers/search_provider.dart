import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/models.dart';

/// Search state class
/// Holds the current state of search functionality
class SearchState {
  final List<SearchHistory> history;
  final String currentQuery;
  final List<String> popularSearches;
  final bool isLoading;
  final String? error;

  const SearchState({
    required this.history,
    required this.currentQuery,
    required this.popularSearches,
    this.isLoading = false,
    this.error,
  });

  /// Initial state with mock data
  factory SearchState.initial() {
    return SearchState(
      history: [
        SearchHistory(
          id: '1',
          query: 'بيتزا',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        SearchHistory(
          id: '2',
          query: 'برجر',
          timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        ),
        SearchHistory(
          id: '3',
          query: 'سوشي',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ],
      currentQuery: '',
      popularSearches: [
        'بيتزا',
        'برجر',
        'شاورما',
        'سوشي',
        'دجاج',
        'مشويات',
      ],
    );
  }

  /// Create a copy with modified fields
  SearchState copyWith({
    List<SearchHistory>? history,
    String? currentQuery,
    List<String>? popularSearches,
    bool? isLoading,
    String? error,
  }) {
    return SearchState(
      history: history ?? this.history,
      currentQuery: currentQuery ?? this.currentQuery,
      popularSearches: popularSearches ?? this.popularSearches,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Search notifier - manages search state
/// Follows architecture rules: business logic separated from UI
class SearchNotifier extends StateNotifier<SearchState> {
  SearchNotifier() : super(SearchState.initial());

  /// Update current search query
  void updateQuery(String query) {
    state = state.copyWith(currentQuery: query);
  }

  /// Add search to history
  /// In production: Sync with backend
  Future<void> addToHistory(String query) async {
    if (query.trim().isEmpty) return;
    
    // Check if query already exists
    final existingIndex = state.history.indexWhere(
      (item) => item.query.toLowerCase() == query.toLowerCase(),
    );
    
    if (existingIndex >= 0) {
      // Update timestamp
      final updatedHistory = List<SearchHistory>.from(state.history);
      updatedHistory[existingIndex] = updatedHistory[existingIndex].copyWith(
        timestamp: DateTime.now(),
      );
      // Move to top
      final item = updatedHistory.removeAt(existingIndex);
      updatedHistory.insert(0, item);
      state = state.copyWith(history: updatedHistory);
    } else {
      // Add new search
      final newSearch = SearchHistory(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        query: query,
        timestamp: DateTime.now(),
      );
      
      final updatedHistory = [newSearch, ...state.history];
      // Keep only last 10 searches
      if (updatedHistory.length > 10) {
        updatedHistory.removeLast();
      }
      
      state = state.copyWith(history: updatedHistory);
    }
    
    // TODO: Sync with backend
    // await _searchApiService.addToHistory(query);
  }

  /// Clear search history
  /// In production: Sync with backend
  Future<void> clearHistory() async {
    state = state.copyWith(history: []);
    
    // TODO: Sync with backend
    // await _searchApiService.clearHistory();
  }

  /// Remove item from history
  /// In production: Sync with backend
  Future<void> removeFromHistory(String id) async {
    final updatedHistory = state.history.where((item) => item.id != id).toList();
    state = state.copyWith(history: updatedHistory);
    
    // TODO: Sync with backend
    // await _searchApiService.removeFromHistory(id);
  }

  /// Load search history from backend
  /// In production: Fetch from API
  Future<void> loadHistory() async {
    state = state.copyWith(isLoading: true);
    
    try {
      // TODO: Replace with actual API call
      // final history = await _searchApiService.getHistory();
      
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

/// Search provider - exposes search state to UI
final searchProvider = StateNotifierProvider<SearchNotifier, SearchState>((ref) {
  return SearchNotifier();
});
