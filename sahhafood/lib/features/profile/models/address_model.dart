/// Address model for user delivery addresses
/// Follows architecture rules: immutable, copyWith pattern, backend-ready
class Address {
  final String id;
  final String label;
  final String fullAddress;
  final String? building;
  final String? floor;
  final String? apartment;
  final String? additionalInstructions;
  final bool isDefault;
  final double? latitude;
  final double? longitude;

  const Address({
    required this.id,
    required this.label,
    required this.fullAddress,
    this.building,
    this.floor,
    this.apartment,
    this.additionalInstructions,
    this.isDefault = false,
    this.latitude,
    this.longitude,
  });

  /// Create a copy with modified fields
  Address copyWith({
    String? id,
    String? label,
    String? fullAddress,
    String? building,
    String? floor,
    String? apartment,
    String? additionalInstructions,
    bool? isDefault,
    double? latitude,
    double? longitude,
  }) {
    return Address(
      id: id ?? this.id,
      label: label ?? this.label,
      fullAddress: fullAddress ?? this.fullAddress,
      building: building ?? this.building,
      floor: floor ?? this.floor,
      apartment: apartment ?? this.apartment,
      additionalInstructions: additionalInstructions ?? this.additionalInstructions,
      isDefault: isDefault ?? this.isDefault,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  /// Create from JSON (for API integration)
  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'] as String,
      label: json['label'] as String,
      fullAddress: json['full_address'] as String,
      building: json['building'] as String?,
      floor: json['floor'] as String?,
      apartment: json['apartment'] as String?,
      additionalInstructions: json['additional_instructions'] as String?,
      isDefault: json['is_default'] as bool? ?? false,
      latitude: json['latitude'] as double?,
      longitude: json['longitude'] as double?,
    );
  }

  /// Convert to JSON (for API integration)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'full_address': fullAddress,
      'building': building,
      'floor': floor,
      'apartment': apartment,
      'additional_instructions': additionalInstructions,
      'is_default': isDefault,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
