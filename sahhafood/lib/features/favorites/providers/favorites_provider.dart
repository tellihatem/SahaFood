/// Favorites provider for managing user's favorite items
/// Follows architecture rules: Riverpod, immutable state, local data

import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/models.dart';

/// Favorites state class
class FavoritesState {
  final List<FavoriteItem> favorites;
  final bool isLoading;
  final String? error;

  const FavoritesState({
    this.favorites = const [],
    this.isLoading = false,
    this.error,
  });

  FavoritesState copyWith({
    List<FavoriteItem>? favorites,
    bool? isLoading,
    String? error,
  }) {
    return FavoritesState(
      favorites: favorites ?? this.favorites,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  /// Check if an item is favorited
  bool isFavorite(String itemId) {
    return favorites.any((fav) => fav.itemId == itemId);
  }

  /// Get favorites by type
  List<FavoriteItem> getFavoritesByType(FavoriteType type) {
    return favorites.where((fav) => fav.type == type).toList();
  }
}

/// Favorites notifier
class FavoritesNotifier extends StateNotifier<FavoritesState> {
  FavoritesNotifier() : super(const FavoritesState()) {
    _loadFavorites();
  }

  /// Load favorites from local storage
  /// In production: Load from shared preferences or local database
  void _loadFavorites() {
    state = state.copyWith(isLoading: true);

    // Mock data - in production, load from local storage
    final mockFavorites = <FavoriteItem>[];

    state = state.copyWith(
      favorites: mockFavorites,
      isLoading: false,
    );
  }

  /// Add item to favorites
  void addFavorite(String itemId, FavoriteType type) {
    // Check if already favorited
    if (state.isFavorite(itemId)) return;

    final newFavorite = FavoriteItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      itemId: itemId,
      type: type,
      addedAt: DateTime.now(),
    );

    final updatedFavorites = [...state.favorites, newFavorite];

    state = state.copyWith(favorites: updatedFavorites);

    // In production: Save to local storage
    _saveFavorites();
  }

  /// Remove item from favorites
  void removeFavorite(String itemId) {
    final updatedFavorites = state.favorites
        .where((fav) => fav.itemId != itemId)
        .toList();

    state = state.copyWith(favorites: updatedFavorites);

    // In production: Save to local storage
    _saveFavorites();
  }

  /// Toggle favorite status
  void toggleFavorite(String itemId, FavoriteType type) {
    if (state.isFavorite(itemId)) {
      removeFavorite(itemId);
    } else {
      addFavorite(itemId, type);
    }
  }

  /// Clear all favorites
  void clearAllFavorites() {
    state = state.copyWith(favorites: []);
    _saveFavorites();
  }

  /// Save favorites to local storage
  /// In production: Use shared_preferences or hive
  void _saveFavorites() {
    // TODO: Implement local storage
    // final prefs = await SharedPreferences.getInstance();
    // final favoritesJson = state.favorites.map((f) => f.toJson()).toList();
    // await prefs.setString('favorites', jsonEncode(favoritesJson));
  }
}

/// Favorites provider
final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, FavoritesState>((ref) {
  return FavoritesNotifier();
});
