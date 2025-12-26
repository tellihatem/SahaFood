import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure storage service for storing sensitive data like tokens
/// Uses flutter_secure_storage for encrypted storage
class SecureStorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  /// Storage keys
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';
  static const String _userRoleKey = 'user_role';

  /// Save access token
  static Future<void> saveAccessToken(String token) async {
    await _storage.write(key: _accessTokenKey, value: token);
  }

  /// Get access token
  static Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  /// Save refresh token
  static Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
  }

  /// Get refresh token
  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  /// Save user ID
  static Future<void> saveUserId(String userId) async {
    await _storage.write(key: _userIdKey, value: userId);
  }

  /// Get user ID
  static Future<String?> getUserId() async {
    return await _storage.read(key: _userIdKey);
  }

  /// Save user role
  static Future<void> saveUserRole(String role) async {
    await _storage.write(key: _userRoleKey, value: role);
  }

  /// Get user role
  static Future<String?> getUserRole() async {
    return await _storage.read(key: _userRoleKey);
  }

  /// Save all auth tokens at once
  static Future<void> saveAuthTokens({
    required String accessToken,
    required String refreshToken,
    String? userId,
    String? role,
  }) async {
    await Future.wait([
      saveAccessToken(accessToken),
      saveRefreshToken(refreshToken),
      if (userId != null) saveUserId(userId),
      if (role != null) saveUserRole(role),
    ]);
  }

  /// Clear all stored data (for logout)
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  /// Check if user has valid tokens stored
  static Future<bool> hasValidTokens() async {
    final accessToken = await getAccessToken();
    final refreshToken = await getRefreshToken();
    return accessToken != null && refreshToken != null;
  }
}
