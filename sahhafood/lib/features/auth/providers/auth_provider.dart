import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/secure_storage_service.dart';
import '../models/models.dart';

/// Auth state class to hold both user and loading/error states
class AuthState {
  final UserModel user;
  final bool isLoading;
  final String? error;
  final bool requiresOtpVerification;
  final String? pendingPhone;

  const AuthState({
    required this.user,
    this.isLoading = false,
    this.error,
    this.requiresOtpVerification = false,
    this.pendingPhone,
  });

  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    String? error,
    bool? requiresOtpVerification,
    String? pendingPhone,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      requiresOtpVerification: requiresOtpVerification ?? this.requiresOtpVerification,
      pendingPhone: pendingPhone ?? this.pendingPhone,
    );
  }

  factory AuthState.initial() {
    return AuthState(user: UserModel.guest());
  }
}

/// Auth state notifier for managing authentication state with API integration
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(AuthState.initial());

  /// Initialize auth state - check for existing tokens
  Future<void> initialize() async {
    state = state.copyWith(isLoading: true);
    try {
      final hasTokens = await SecureStorageService.hasValidTokens();
      if (hasTokens) {
        // Try to get current user
        final userResponse = await _authService.getMe();
        state = state.copyWith(
          user: UserModel.fromUserResponse(userResponse),
          isLoading: false,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      // Clear invalid tokens
      await SecureStorageService.clearAll();
      state = state.copyWith(isLoading: false);
    }
  }

  /// Login with phone and password
  Future<bool> login({
    required String phone,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _authService.login(
        phone: phone,
        password: password,
      );

      // Check if verification is required
      if (response.requiresVerification == true) {
        state = state.copyWith(
          isLoading: false,
          requiresOtpVerification: true,
          pendingPhone: phone,
        );
        return false;
      }

      // Login successful
      if (response.user != null) {
        state = state.copyWith(
          user: UserModel.fromUserResponse(response.user!),
          isLoading: false,
          requiresOtpVerification: false,
        );
        return true;
      }

      state = state.copyWith(isLoading: false);
      return false;
    } on AuthException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'حدث خطأ غير متوقع');
      return false;
    }
  }

  /// Register new user
  Future<bool> register({
    required String phone,
    required String name,
    String? password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _authService.register(
        phone: phone,
        name: name,
        password: password,
      );

      // Registration requires OTP verification
      if (response.requiresVerification == true) {
        state = state.copyWith(
          isLoading: false,
          requiresOtpVerification: true,
          pendingPhone: phone,
        );
        return true;
      }

      state = state.copyWith(isLoading: false);
      return true;
    } on AuthException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'حدث خطأ غير متوقع');
      return false;
    }
  }

  /// Send OTP to phone number
  Future<bool> sendOtp({required String phone}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _authService.sendOtp(phone: phone);
      state = state.copyWith(
        isLoading: false,
        requiresOtpVerification: true,
        pendingPhone: phone,
      );
      return true;
    } on AuthException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'حدث خطأ غير متوقع');
      return false;
    }
  }

  /// Verify OTP
  Future<bool> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _authService.verifyOtp(
        phone: phone,
        otp: otp,
      );

      if (response.user != null) {
        state = state.copyWith(
          user: UserModel.fromUserResponse(response.user!),
          isLoading: false,
          requiresOtpVerification: false,
          pendingPhone: null,
        );
        return true;
      }

      state = state.copyWith(isLoading: false);
      return false;
    } on AuthException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'حدث خطأ غير متوقع');
      return false;
    }
  }

  /// Complete user profile
  Future<bool> completeProfile({
    required String name,
    String? password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _authService.completeProfile(
        name: name,
        password: password,
      );

      if (response.user != null) {
        state = state.copyWith(
          user: state.user.copyWith(fullName: response.user!.name),
          isLoading: false,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
      return true;
    } on AuthException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'حدث خطأ غير متوقع');
      return false;
    }
  }

  /// Update user role (for role selection screen)
  void setUserRole(UserRole role) {
    state = state.copyWith(user: state.user.copyWith(role: role));
  }

  /// Logout user
  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    try {
      await _authService.logout();
    } finally {
      state = AuthState.initial();
    }
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Check if user is logged in
  bool get isLoggedIn => state.user.isLoggedIn;
  
  /// Get current user role
  UserRole get userRole => state.user.role;
}

/// Auth service provider
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

/// Provider for auth state
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService);
});

/// Helper provider to check if user is logged in
final isLoggedInProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  return authState.user.isLoggedIn;
});

/// Helper provider to get current user role
final userRoleProvider = Provider<UserRole>((ref) {
  final authState = ref.watch(authProvider);
  return authState.user.role;
});

/// Helper provider to check if loading
final authLoadingProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  return authState.isLoading;
});

/// Helper provider to get auth error
final authErrorProvider = Provider<String?>((ref) {
  final authState = ref.watch(authProvider);
  return authState.error;
});

/// Helper provider to check if OTP verification is required
final requiresOtpProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  return authState.requiresOtpVerification;
});

/// Helper provider to get pending phone for OTP
final pendingPhoneProvider = Provider<String?>((ref) {
  final authState = ref.watch(authProvider);
  return authState.pendingPhone;
});
