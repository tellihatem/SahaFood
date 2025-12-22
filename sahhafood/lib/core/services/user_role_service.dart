import 'package:flutter/foundation.dart';

/// User role enum
enum UserRole {
  client,
  chef,
  delivery,
}

/// Mock service to manage user roles for testing
/// This will be replaced with actual backend authentication later
class UserRoleService extends ChangeNotifier {
  static final UserRoleService _instance = UserRoleService._internal();
  
  factory UserRoleService() {
    return _instance;
  }
  
  UserRoleService._internal();
  
  UserRole _currentRole = UserRole.client;
  
  UserRole get currentRole => _currentRole;
  
  bool get isClient => _currentRole == UserRole.client;
  bool get isChef => _currentRole == UserRole.chef;
  bool get isDelivery => _currentRole == UserRole.delivery;
  
  /// Switch user role (for testing purposes only)
  void switchRole(UserRole role) {
    _currentRole = role;
    notifyListeners();
  }
  
  /// Toggle between client and chef roles
  void toggleRole() {
    _currentRole = _currentRole == UserRole.client 
        ? UserRole.chef 
        : UserRole.client;
    notifyListeners();
  }
  
  /// Reset to client role
  void reset() {
    _currentRole = UserRole.client;
    notifyListeners();
  }
}
