import '../../../core/services/auth_service.dart';

/// User model for state management with API integration
class UserModel {
  /// User's unique identifier
  final String id;
  
  /// User's phone number (with country code)
  final String phoneNumber;
  
  /// User's full name
  final String? fullName;
  
  /// User's role (user, restaurant, delivery, admin)
  final UserRole role;
  
  /// Whether the user is currently logged in
  final bool isLoggedIn;

  /// User's profile image URL
  final String? profileImage;

  /// Whether phone is verified
  final bool phoneVerified;

  /// User's gender
  final String? gender;

  /// User's birthdate
  final DateTime? birthdate;

  const UserModel({
    required this.id,
    required this.phoneNumber,
    this.fullName,
    required this.role,
    this.isLoggedIn = false,
    this.profileImage,
    this.phoneVerified = false,
    this.gender,
    this.birthdate,
  });

  /// Create a copy with updated fields
  UserModel copyWith({
    String? id,
    String? phoneNumber,
    String? fullName,
    UserRole? role,
    bool? isLoggedIn,
    String? profileImage,
    bool? phoneVerified,
    String? gender,
    DateTime? birthdate,
  }) {
    return UserModel(
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      profileImage: profileImage ?? this.profileImage,
      phoneVerified: phoneVerified ?? this.phoneVerified,
      gender: gender ?? this.gender,
      birthdate: birthdate ?? this.birthdate,
    );
  }

  /// Create an empty/guest user
  factory UserModel.guest() {
    return const UserModel(
      id: '',
      phoneNumber: '',
      role: UserRole.user,
      isLoggedIn: false,
    );
  }

  /// Create from API UserResponse
  factory UserModel.fromUserResponse(UserResponse response, {bool isLoggedIn = true}) {
    return UserModel(
      id: response.id,
      phoneNumber: response.phone,
      fullName: response.name,
      role: UserRole.fromString(response.role),
      isLoggedIn: isLoggedIn,
      profileImage: response.profileImage,
      phoneVerified: response.phoneVerified,
      gender: response.gender,
      birthdate: response.birthdate,
    );
  }

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'fullName': fullName,
      'role': role.value,
      'isLoggedIn': isLoggedIn,
      'profileImage': profileImage,
      'phoneVerified': phoneVerified,
      'gender': gender,
      'birthdate': birthdate?.toIso8601String(),
    };
  }

  /// Create from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      fullName: json['fullName'],
      role: UserRole.fromString(json['role'] ?? 'user'),
      isLoggedIn: json['isLoggedIn'] ?? false,
      profileImage: json['profileImage'],
      phoneVerified: json['phoneVerified'] ?? false,
      gender: json['gender'],
      birthdate: json['birthdate'] != null ? DateTime.tryParse(json['birthdate']) : null,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, phoneNumber: $phoneNumber, fullName: $fullName, role: $role, isLoggedIn: $isLoggedIn)';
  }
}

/// User role enumeration matching backend roles
enum UserRole {
  user('user'),
  restaurant('restaurant'),
  delivery('delivery'),
  admin('admin');

  final String value;
  const UserRole(this.value);

  /// Create from string value
  static UserRole fromString(String value) {
    switch (value.toLowerCase()) {
      case 'restaurant':
      case 'chef':
        return UserRole.restaurant;
      case 'delivery':
        return UserRole.delivery;
      case 'admin':
        return UserRole.admin;
      default:
        return UserRole.user;
    }
  }

  /// Check if role requires role selection screen
  bool get requiresRoleSelection => this == UserRole.restaurant || this == UserRole.delivery;
}
