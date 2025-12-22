/// User profile model
/// Follows architecture rules: immutable, copyWith pattern, backend-ready
class UserProfile {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? profileImageUrl;
  final DateTime? dateOfBirth;
  final String? gender;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.profileImageUrl,
    this.dateOfBirth,
    this.gender,
  });

  /// Create initial profile with mock data
  factory UserProfile.initial() {
    return UserProfile(
      id: '1',
      name: 'فيشال خاداك',
      email: 'vishal@example.com',
      phone: '+966 55 123 4567',
      profileImageUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=200',
      dateOfBirth: DateTime(1995, 5, 15),
      gender: 'ذكر',
    );
  }

  /// Create a copy with modified fields
  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? profileImageUrl,
    DateTime? dateOfBirth,
    String? gender,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
    );
  }

  /// Create from JSON (for API integration)
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      profileImageUrl: json['profile_image_url'] as String?,
      dateOfBirth: json['date_of_birth'] != null 
          ? DateTime.parse(json['date_of_birth'] as String)
          : null,
      gender: json['gender'] as String?,
    );
  }

  /// Convert to JSON (for API integration)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'profile_image_url': profileImageUrl,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'gender': gender,
    };
  }
}
