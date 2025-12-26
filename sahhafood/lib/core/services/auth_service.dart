import 'package:dio/dio.dart';
import '../config/api_config.dart';
import 'api_service.dart';
import 'secure_storage_service.dart';

/// Authentication service for handling auth-related API calls
class AuthService {
  final ApiService _apiService = ApiService.instance;

  /// Register a new user
  /// Returns registration response with userId and requiresVerification flag
  Future<AuthResponse> register({
    required String phone,
    required String name,
    String? password,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConfig.authRegister,
        data: {
          'phone': phone,
          'name': name,
          if (password != null) 'password': password,
        },
      );

      return AuthResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Login with phone and password
  Future<AuthResponse> login({
    required String phone,
    required String password,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConfig.authLogin,
        data: {
          'phone': phone,
          'password': password,
        },
      );

      final authResponse = AuthResponse.fromJson(response.data);

      // Save tokens if login successful
      if (authResponse.accessToken != null) {
        await SecureStorageService.saveAuthTokens(
          accessToken: authResponse.accessToken!,
          refreshToken: authResponse.refreshToken!,
          userId: authResponse.user?.id,
          role: authResponse.user?.role,
        );
      }

      return authResponse;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Send OTP to phone number
  Future<OtpResponse> sendOtp({required String phone}) async {
    try {
      final response = await _apiService.post(
        ApiConfig.authSendOtp,
        data: {'phone': phone},
      );

      return OtpResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Verify OTP and complete login/registration
  Future<AuthResponse> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConfig.authVerifyOtp,
        data: {
          'phone': phone,
          'otp': otp,
        },
      );

      final authResponse = AuthResponse.fromJson(response.data);

      // Save tokens if verification successful
      if (authResponse.accessToken != null) {
        await SecureStorageService.saveAuthTokens(
          accessToken: authResponse.accessToken!,
          refreshToken: authResponse.refreshToken!,
          userId: authResponse.user?.id,
          role: authResponse.user?.role,
        );
      }

      return authResponse;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get current user profile
  Future<UserResponse> getMe() async {
    try {
      final response = await _apiService.get(ApiConfig.authMe);
      return UserResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Complete or update user profile
  Future<AuthResponse> completeProfile({
    required String name,
    String? password,
  }) async {
    try {
      final response = await _apiService.patch(
        ApiConfig.authProfile,
        data: {
          'name': name,
          if (password != null) 'password': password,
        },
      );

      return AuthResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Logout user
  Future<void> logout({String? refreshToken}) async {
    try {
      final token = refreshToken ?? await SecureStorageService.getRefreshToken();
      await _apiService.post(
        ApiConfig.authLogout,
        data: {
          if (token != null) 'refreshToken': token,
        },
      );
    } catch (_) {
      // Ignore logout errors
    } finally {
      // Always clear local storage
      await SecureStorageService.clearAll();
    }
  }

  /// Refresh access token
  Future<bool> refreshToken() async {
    try {
      final refreshToken = await SecureStorageService.getRefreshToken();
      if (refreshToken == null) return false;

      final response = await _apiService.post(
        ApiConfig.authRefresh,
        data: {'refreshToken': refreshToken},
      );

      final data = response.data;
      await SecureStorageService.saveAuthTokens(
        accessToken: data['accessToken'],
        refreshToken: data['refreshToken'],
      );

      return true;
    } catch (_) {
      return false;
    }
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    return await SecureStorageService.hasValidTokens();
  }

  /// Handle Dio errors and convert to AuthException
  AuthException _handleError(DioException e) {
    final statusCode = e.response?.statusCode;
    final data = e.response?.data;

    String message = 'حدث خطأ غير متوقع';

    if (data is Map<String, dynamic>) {
      message = data['message'] ?? message;
    }

    switch (statusCode) {
      case 400:
        return AuthException(message: message, code: 'BAD_REQUEST');
      case 401:
        return AuthException(message: message, code: 'UNAUTHORIZED');
      case 409:
        return AuthException(message: message, code: 'CONFLICT');
      case 429:
        return AuthException(message: 'تم تجاوز الحد الأقصى للطلبات. حاول لاحقاً', code: 'RATE_LIMIT');
      default:
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          return AuthException(message: 'انتهت مهلة الاتصال. تحقق من اتصالك بالإنترنت', code: 'TIMEOUT');
        }
        if (e.type == DioExceptionType.connectionError) {
          return AuthException(message: 'فشل الاتصال بالخادم. تحقق من اتصالك بالإنترنت', code: 'CONNECTION_ERROR');
        }
        return AuthException(message: message, code: 'UNKNOWN');
    }
  }
}

/// Auth exception class
class AuthException implements Exception {
  final String message;
  final String code;

  AuthException({required this.message, required this.code});

  @override
  String toString() => message;
}

/// Auth response model
class AuthResponse {
  final String? accessToken;
  final String? refreshToken;
  final int? expiresIn;
  final bool? isNewUser;
  final bool? requiresVerification;
  final String? message;
  final String? userId;
  final UserResponse? user;

  AuthResponse({
    this.accessToken,
    this.refreshToken,
    this.expiresIn,
    this.isNewUser,
    this.requiresVerification,
    this.message,
    this.userId,
    this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      expiresIn: json['expiresIn'],
      isNewUser: json['isNewUser'],
      requiresVerification: json['requiresVerification'],
      message: json['message'],
      userId: json['userId'],
      user: json['user'] != null ? UserResponse.fromJson(json['user']) : null,
    );
  }
}

/// OTP response model
class OtpResponse {
  final String message;
  final int expiresIn;

  OtpResponse({required this.message, required this.expiresIn});

  factory OtpResponse.fromJson(Map<String, dynamic> json) {
    return OtpResponse(
      message: json['message'] ?? '',
      expiresIn: json['expiresIn'] ?? 300,
    );
  }
}

/// User response model
class UserResponse {
  final String id;
  final String phone;
  final String? name;
  final String role;
  final String? profileImage;
  final String? gender;
  final DateTime? birthdate;
  final bool phoneVerified;
  final DateTime? createdAt;

  UserResponse({
    required this.id,
    required this.phone,
    this.name,
    required this.role,
    this.profileImage,
    this.gender,
    this.birthdate,
    this.phoneVerified = false,
    this.createdAt,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      id: json['id'] ?? '',
      phone: json['phone'] ?? '',
      name: json['name'],
      role: json['role'] ?? 'user',
      profileImage: json['profile_image'],
      gender: json['gender'],
      birthdate: json['birthdate'] != null ? DateTime.tryParse(json['birthdate']) : null,
      phoneVerified: json['phone_verified'] ?? false,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'name': name,
      'role': role,
      'profile_image': profileImage,
      'gender': gender,
      'birthdate': birthdate?.toIso8601String(),
      'phone_verified': phoneVerified,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
