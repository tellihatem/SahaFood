/// Simple user model for local state management
/// No serialization needed - data is kept in memory only
class UserModel {
  /// User's unique identifier
  final String id;
  
  /// User's phone number (without country code)
  final String phoneNumber;
  
  /// User's full name
  final String? fullName;
  
  /// User's role (customer, chef, delivery)
  final UserRole role;
  
  /// Whether the user is currently logged in
  final bool isLoggedIn;

  const UserModel({
    required this.id,
    required this.phoneNumber,
    this.fullName,
    required this.role,
    this.isLoggedIn = false,
  });

  /// Create a copy with updated fields
  UserModel copyWith({
    String? id,
    String? phoneNumber,
    String? fullName,
    UserRole? role,
    bool? isLoggedIn,
  }) {
    return UserModel(
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }

  /// Create an empty/guest user
  factory UserModel.guest() {
    return const UserModel(
      id: '',
      phoneNumber: '',
      role: UserRole.customer,
      isLoggedIn: false,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, phoneNumber: $phoneNumber, fullName: $fullName, role: $role, isLoggedIn: $isLoggedIn)';
  }
}

/// User role enumeration
enum UserRole {
  customer,
  chef,
  delivery,
}
