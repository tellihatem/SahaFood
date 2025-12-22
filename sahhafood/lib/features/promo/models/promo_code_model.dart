/// Promo code model
/// Follows architecture rules: immutable, copyWith pattern, backend-ready

enum PromoType {
  percentage, // Percentage discount (e.g., 20%)
  fixed, // Fixed amount discount (e.g., 100 DZD)
  freeDelivery, // Free delivery
}

enum PromoStatus {
  active,
  expired,
  used,
}

class PromoCode {
  final String id;
  final String code;
  final String title;
  final String description;
  final PromoType type;
  final double value; // Percentage or fixed amount
  final double? minOrderAmount; // Minimum order amount to use promo
  final DateTime? expiryDate;
  final PromoStatus status;
  final bool isExclusive; // If true, cannot be combined with other promos
  final String? imageUrl;

  const PromoCode({
    required this.id,
    required this.code,
    required this.title,
    required this.description,
    required this.type,
    required this.value,
    this.minOrderAmount,
    this.expiryDate,
    this.status = PromoStatus.active,
    this.isExclusive = false,
    this.imageUrl,
  });

  /// Check if promo is expired
  bool get isExpired {
    if (expiryDate == null) return false;
    return DateTime.now().isAfter(expiryDate!);
  }

  /// Check if promo is active
  bool get isActive => status == PromoStatus.active && !isExpired;

  /// Get remaining days
  int? get remainingDays {
    if (expiryDate == null) return null;
    final difference = expiryDate!.difference(DateTime.now());
    return difference.inDays;
  }

  /// Get discount text
  String get discountText {
    switch (type) {
      case PromoType.percentage:
        return '${value.toInt()}%';
      case PromoType.fixed:
        return '${value.toInt()} دج';
      case PromoType.freeDelivery:
        return 'توصيل مجاني';
    }
  }

  /// Create a copy with modified fields
  PromoCode copyWith({
    String? id,
    String? code,
    String? title,
    String? description,
    PromoType? type,
    double? value,
    double? minOrderAmount,
    DateTime? expiryDate,
    PromoStatus? status,
    bool? isExclusive,
    String? imageUrl,
  }) {
    return PromoCode(
      id: id ?? this.id,
      code: code ?? this.code,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      value: value ?? this.value,
      minOrderAmount: minOrderAmount ?? this.minOrderAmount,
      expiryDate: expiryDate ?? this.expiryDate,
      status: status ?? this.status,
      isExclusive: isExclusive ?? this.isExclusive,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  /// Create from JSON (for API integration)
  factory PromoCode.fromJson(Map<String, dynamic> json) {
    return PromoCode(
      id: json['id'] as String,
      code: json['code'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: PromoType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => PromoType.percentage,
      ),
      value: (json['value'] as num).toDouble(),
      minOrderAmount: json['min_order_amount'] as double?,
      expiryDate: json['expiry_date'] != null
          ? DateTime.parse(json['expiry_date'] as String)
          : null,
      status: PromoStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => PromoStatus.active,
      ),
      isExclusive: json['is_exclusive'] as bool? ?? false,
      imageUrl: json['image_url'] as String?,
    );
  }

  /// Convert to JSON (for API integration)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'title': title,
      'description': description,
      'type': type.name,
      'value': value,
      'min_order_amount': minOrderAmount,
      'expiry_date': expiryDate?.toIso8601String(),
      'status': status.name,
      'is_exclusive': isExclusive,
      'image_url': imageUrl,
    };
  }
}
