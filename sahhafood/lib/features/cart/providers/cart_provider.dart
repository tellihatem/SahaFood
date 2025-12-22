import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/models.dart';

/// Cart state class
/// Holds the current state of the shopping cart
class CartState {
  final List<CartItem> items;
  final String deliveryAddress;
  final bool isLoading;
  final String? error;

  const CartState({
    required this.items,
    required this.deliveryAddress,
    this.isLoading = false,
    this.error,
  });

  /// Initial state with empty cart
  factory CartState.initial() {
    return const CartState(
      items: [],
      deliveryAddress: '2118 Thornridge Cir. Syracuse',
    );
  }

  /// Calculate subtotal
  double get subtotal {
    return items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  /// Calculate total items count
  int get totalItems {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  /// Check if cart is empty
  bool get isEmpty => items.isEmpty;

  /// Create a copy with modified fields
  CartState copyWith({
    List<CartItem>? items,
    String? deliveryAddress,
    bool? isLoading,
    String? error,
  }) {
    return CartState(
      items: items ?? this.items,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Cart notifier - manages cart state
/// Follows architecture rules: business logic separated from UI
class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(CartState.initial()) {
    _loadInitialData();
  }

  /// Load initial mock data
  /// In production: Replace with API call
  void _loadInitialData() {
    final mockItems = [
      const CartItem(
        id: '1',
        name: 'بيتزا كالزوني',
        description: 'أوروبية',
        price: 64,
        quantity: 1,
        imageUrl: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=200',
      ),
      const CartItem(
        id: '2',
        name: 'بيتزا كالزوني',
        description: 'أوروبية',
        price: 32,
        quantity: 1,
        imageUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=200',
      ),
    ];
    
    state = state.copyWith(items: mockItems);
  }

  /// Add item to cart
  /// In production: Sync with backend
  void addItem(CartItem item) {
    final existingIndex = state.items.indexWhere((i) => i.id == item.id);
    
    if (existingIndex >= 0) {
      // Item exists, increment quantity
      incrementQuantity(existingIndex);
    } else {
      // New item, add to cart
      final updatedItems = [...state.items, item];
      state = state.copyWith(items: updatedItems);
    }
  }

  /// Remove item from cart
  /// In production: Sync with backend
  void removeItem(int index) {
    final updatedItems = List<CartItem>.from(state.items);
    updatedItems.removeAt(index);
    state = state.copyWith(items: updatedItems);
  }

  /// Increment item quantity
  /// In production: Sync with backend
  void incrementQuantity(int index) {
    final updatedItems = List<CartItem>.from(state.items);
    updatedItems[index] = updatedItems[index].copyWith(
      quantity: updatedItems[index].quantity + 1,
    );
    state = state.copyWith(items: updatedItems);
  }

  /// Decrement item quantity
  /// In production: Sync with backend
  void decrementQuantity(int index) {
    final updatedItems = List<CartItem>.from(state.items);
    if (updatedItems[index].quantity > 1) {
      updatedItems[index] = updatedItems[index].copyWith(
        quantity: updatedItems[index].quantity - 1,
      );
      state = state.copyWith(items: updatedItems);
    }
  }

  /// Update delivery address
  /// In production: Sync with backend
  void updateDeliveryAddress(String address) {
    state = state.copyWith(deliveryAddress: address);
  }

  /// Clear cart
  /// In production: Sync with backend
  void clearCart() {
    state = state.copyWith(items: []);
  }

  /// Place order
  /// In production: Call API endpoint
  Future<bool> placeOrder() async {
    state = state.copyWith(isLoading: true);
    
    try {
      // TODO: Replace with actual API call
      // await _cartApiService.placeOrder(state.items);
      
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Clear cart after successful order
      clearCart();
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }
}

/// Cart provider - exposes cart state to UI
final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});
