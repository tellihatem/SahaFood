import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/models.dart';

/// Address state class
/// Holds the current state of user addresses
class AddressState {
  final List<Address> addresses;
  final bool isLoading;
  final String? error;

  const AddressState({
    required this.addresses,
    this.isLoading = false,
    this.error,
  });

  /// Initial state with mock addresses
  factory AddressState.initial() {
    return AddressState(
      addresses: [
        const Address(
          id: '1',
          label: 'المنزل',
          fullAddress: '2118 Thornridge Cir. Syracuse',
          building: 'مبنى A',
          floor: '5',
          apartment: '502',
          isDefault: true,
          latitude: 24.7136,
          longitude: 46.6753,
        ),
        const Address(
          id: '2',
          label: 'العمل',
          fullAddress: '4517 Washington Ave. Manchester',
          building: 'برج المملكة',
          floor: '12',
          apartment: '1205',
          isDefault: false,
          latitude: 24.7143,
          longitude: 46.6761,
        ),
      ],
    );
  }

  /// Get default address
  Address? get defaultAddress {
    try {
      return addresses.firstWhere((addr) => addr.isDefault);
    } catch (e) {
      return addresses.isNotEmpty ? addresses.first : null;
    }
  }

  /// Create a copy with modified fields
  AddressState copyWith({
    List<Address>? addresses,
    bool? isLoading,
    String? error,
  }) {
    return AddressState(
      addresses: addresses ?? this.addresses,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Address notifier - manages address state
/// Follows architecture rules: business logic separated from UI
class AddressNotifier extends StateNotifier<AddressState> {
  AddressNotifier() : super(AddressState.initial());

  /// Add new address
  /// In production: Call API endpoint
  Future<bool> addAddress(Address address) async {
    state = state.copyWith(isLoading: true);
    
    try {
      // TODO: Replace with actual API call
      // await _addressApiService.addAddress(address);
      
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));
      
      final updatedAddresses = [...state.addresses, address];
      state = state.copyWith(
        addresses: updatedAddresses,
        isLoading: false,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  /// Update existing address
  /// In production: Call API endpoint
  Future<bool> updateAddress(Address updatedAddress) async {
    state = state.copyWith(isLoading: true);
    
    try {
      // TODO: Replace with actual API call
      // await _addressApiService.updateAddress(updatedAddress);
      
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));
      
      final updatedAddresses = state.addresses.map((addr) {
        return addr.id == updatedAddress.id ? updatedAddress : addr;
      }).toList();
      
      state = state.copyWith(
        addresses: updatedAddresses,
        isLoading: false,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  /// Delete address
  /// In production: Call API endpoint
  Future<bool> deleteAddress(String addressId) async {
    state = state.copyWith(isLoading: true);
    
    try {
      // TODO: Replace with actual API call
      // await _addressApiService.deleteAddress(addressId);
      
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));
      
      final updatedAddresses = state.addresses
          .where((addr) => addr.id != addressId)
          .toList();
      
      state = state.copyWith(
        addresses: updatedAddresses,
        isLoading: false,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  /// Set address as default
  /// In production: Call API endpoint
  Future<bool> setDefaultAddress(String addressId) async {
    state = state.copyWith(isLoading: true);
    
    try {
      // TODO: Replace with actual API call
      // await _addressApiService.setDefaultAddress(addressId);
      
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));
      
      final updatedAddresses = state.addresses.map((addr) {
        return addr.copyWith(isDefault: addr.id == addressId);
      }).toList();
      
      state = state.copyWith(
        addresses: updatedAddresses,
        isLoading: false,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  /// Load addresses from backend
  /// In production: Fetch from API
  Future<void> loadAddresses() async {
    state = state.copyWith(isLoading: true);
    
    try {
      // TODO: Replace with actual API call
      // final addresses = await _addressApiService.getAddresses();
      
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Using mock data for now
      final addresses = AddressState.initial().addresses;
      
      state = state.copyWith(
        addresses: addresses,
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

/// Address provider - exposes address state to UI
final addressProvider = StateNotifierProvider<AddressNotifier, AddressState>((ref) {
  return AddressNotifier();
});
