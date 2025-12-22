/// Local-only delivery person model
/// No serialization - data stays in memory
class DeliveryPerson {
  final String id;
  final String name;
  final String phone;
  final String vehicleType;
  final String vehicleNumber;
  final double rating;
  final int totalDeliveries;
  final double totalEarnings;
  final bool isAvailable;

  DeliveryPerson({
    required this.id,
    required this.name,
    required this.phone,
    required this.vehicleType,
    required this.vehicleNumber,
    required this.rating,
    required this.totalDeliveries,
    required this.totalEarnings,
    this.isAvailable = true,
  });

  /// Create a copy with updated fields
  DeliveryPerson copyWith({
    String? id,
    String? name,
    String? phone,
    String? vehicleType,
    String? vehicleNumber,
    double? rating,
    int? totalDeliveries,
    double? totalEarnings,
    bool? isAvailable,
  }) {
    return DeliveryPerson(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      vehicleType: vehicleType ?? this.vehicleType,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      rating: rating ?? this.rating,
      totalDeliveries: totalDeliveries ?? this.totalDeliveries,
      totalEarnings: totalEarnings ?? this.totalEarnings,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}
