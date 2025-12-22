import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/models.dart';

/// Auth state notifier for managing authentication state locally
/// No API calls - all state is kept in memory
class AuthNotifier extends StateNotifier<UserModel> {
  AuthNotifier() : super(UserModel.guest());

  /// Simulate login with phone and password
  /// In a real app, this would validate against stored credentials
  Future<bool> login({
    required String phoneNumber,
    required String password,
  }) async {
    // Simulate processing delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Simple validation - in real app, check against stored data
    if (phoneNumber.length == 9 && password.length >= 6) {
      state = UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        phoneNumber: phoneNumber,
        fullName: 'مستخدم',
        role: UserRole.customer,
        isLoggedIn: true,
      );
      return true;
    }
    
    return false;
  }

  /// Simulate signup with user details
  Future<bool> signup({
    required String phoneNumber,
    required String password,
    required String fullName,
  }) async {
    // Simulate processing delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Create new user
    state = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      phoneNumber: phoneNumber,
      fullName: fullName,
      role: UserRole.customer,
      isLoggedIn: true,
    );
    
    return true;
  }

  /// Update user role
  void setUserRole(UserRole role) {
    state = state.copyWith(role: role);
  }

  /// Logout user
  void logout() {
    state = UserModel.guest();
  }

  /// Check if user is logged in
  bool get isLoggedIn => state.isLoggedIn;
  
  /// Get current user role
  UserRole get userRole => state.role;
}

/// Provider for auth state
final authProvider = StateNotifierProvider<AuthNotifier, UserModel>((ref) {
  return AuthNotifier();
});

/// Helper provider to check if user is logged in
final isLoggedInProvider = Provider<bool>((ref) {
  final user = ref.watch(authProvider);
  return user.isLoggedIn;
});

/// Helper provider to get current user role
final userRoleProvider = Provider<UserRole>((ref) {
  final user = ref.watch(authProvider);
  return user.role;
});
