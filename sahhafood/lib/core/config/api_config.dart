/// API Configuration for the application
/// Contains base URLs and API endpoints
class ApiConfig {
  ApiConfig._();

  /// Base URL for the API - change this for different environments
  static const String baseUrl = 'http://10.0.2.2:3000'; // Android emulator localhost
  // static const String baseUrl = 'http://localhost:3000'; // iOS simulator / Web
  // static const String baseUrl = 'https://api.sahhafood.com'; // Production

  /// API version prefix
  static const String apiVersion = '/api/v1';

  /// Full API base URL
  static String get apiBaseUrl => '$baseUrl$apiVersion';

  /// Auth endpoints
  static const String authRegister = '/auth/register';
  static const String authLogin = '/auth/login';
  static const String authSendOtp = '/auth/otp/send';
  static const String authVerifyOtp = '/auth/otp/verify';
  static const String authRefresh = '/auth/refresh';
  static const String authMe = '/auth/me';
  static const String authProfile = '/auth/profile';
  static const String authLogout = '/auth/logout';

  /// Request timeout durations
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
}
