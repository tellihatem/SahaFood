/// Chef delivery person model - for managing delivery team
class ChefDeliveryPerson {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String? photoUrl;
  final ChefDeliveryPersonStatus status;
  final VehicleInfo vehicle;
  final int totalDeliveries;
  final double rating;
  final DateTime joinedDate;
  final String? currentOrderId;

  ChefDeliveryPerson({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    this.photoUrl,
    required this.status,
    required this.vehicle,
    this.totalDeliveries = 0,
    this.rating = 0.0,
    required this.joinedDate,
    this.currentOrderId,
  });

  ChefDeliveryPerson copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? photoUrl,
    ChefDeliveryPersonStatus? status,
    VehicleInfo? vehicle,
    int? totalDeliveries,
    double? rating,
    DateTime? joinedDate,
    String? currentOrderId,
  }) {
    return ChefDeliveryPerson(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      status: status ?? this.status,
      vehicle: vehicle ?? this.vehicle,
      totalDeliveries: totalDeliveries ?? this.totalDeliveries,
      rating: rating ?? this.rating,
      joinedDate: joinedDate ?? this.joinedDate,
      currentOrderId: currentOrderId ?? this.currentOrderId,
    );
  }
}

/// Delivery person status
enum ChefDeliveryPersonStatus {
  available,
  busy,
  offline,
}

/// Vehicle information
class VehicleInfo {
  final String type; // سيارة, دراجة نارية, دراجة
  final String model;
  final String plateNumber;
  final String? color;

  VehicleInfo({
    required this.type,
    required this.model,
    required this.plateNumber,
    this.color,
  });
}

/// Helper extension for status display
extension ChefDeliveryPersonStatusExtension on ChefDeliveryPersonStatus {
  String get displayName {
    switch (this) {
      case ChefDeliveryPersonStatus.available:
        return 'متاح';
      case ChefDeliveryPersonStatus.busy:
        return 'مشغول';
      case ChefDeliveryPersonStatus.offline:
        return 'غير متصل';
    }
  }
}
