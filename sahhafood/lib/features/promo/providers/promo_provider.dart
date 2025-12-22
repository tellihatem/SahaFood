/// Promo code provider for managing promotional offers
/// Follows architecture rules: Riverpod, immutable state, local data

import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/models.dart';

/// Promo state class
class PromoState {
  final List<PromoCode> promoCodes;
  final PromoCode? appliedPromo;
  final bool isLoading;
  final String? error;

  const PromoState({
    this.promoCodes = const [],
    this.appliedPromo,
    this.isLoading = false,
    this.error,
  });

  PromoState copyWith({
    List<PromoCode>? promoCodes,
    PromoCode? appliedPromo,
    bool? isLoading,
    String? error,
    bool clearAppliedPromo = false,
  }) {
    return PromoState(
      promoCodes: promoCodes ?? this.promoCodes,
      appliedPromo: clearAppliedPromo ? null : (appliedPromo ?? this.appliedPromo),
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  /// Get active promo codes
  List<PromoCode> get activePromoCodes {
    return promoCodes.where((promo) => promo.isActive).toList();
  }

  /// Get expired promo codes
  List<PromoCode> get expiredPromoCodes {
    return promoCodes.where((promo) => promo.isExpired).toList();
  }
}

/// Promo notifier
class PromoNotifier extends StateNotifier<PromoState> {
  PromoNotifier() : super(const PromoState()) {
    _loadPromoCodes();
  }

  /// Load promo codes
  /// In production: Fetch from API
  void _loadPromoCodes() {
    state = state.copyWith(isLoading: true);

    // Mock data - in production, this would be an API call
    final mockPromoCodes = [
      PromoCode(
        id: '1',
        code: 'WELCOME30',
        title: 'خصم 30% على طلبك الأول',
        description: 'احصل على خصم 30% على طلبك الأول عند استخدام هذا الكود',
        type: PromoType.percentage,
        value: 30,
        minOrderAmount: 500,
        expiryDate: DateTime.now().add(const Duration(days: 7)),
        imageUrl: 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=400',
      ),
      PromoCode(
        id: '2',
        code: 'FREEDEL',
        title: 'توصيل مجاني',
        description: 'توصيل مجاني لجميع الطلبات فوق 1000 دج',
        type: PromoType.freeDelivery,
        value: 0,
        minOrderAmount: 1000,
        expiryDate: DateTime.now().add(const Duration(days: 14)),
        imageUrl: 'https://images.unsplash.com/photo-1526367790999-0150786686a2?w=400',
      ),
      PromoCode(
        id: '3',
        code: 'SAVE200',
        title: 'وفر 200 دج',
        description: 'خصم 200 دج على طلبات أكثر من 1500 دج',
        type: PromoType.fixed,
        value: 200,
        minOrderAmount: 1500,
        expiryDate: DateTime.now().add(const Duration(days: 3)),
        imageUrl: 'https://images.unsplash.com/photo-1607083206869-4c7672e72a8a?w=400',
      ),
      PromoCode(
        id: '4',
        code: 'WEEKEND25',
        title: 'خصم نهاية الأسبوع 25%',
        description: 'خصم خاص لعطلة نهاية الأسبوع',
        type: PromoType.percentage,
        value: 25,
        minOrderAmount: 800,
        expiryDate: DateTime.now().add(const Duration(days: 2)),
        isExclusive: true,
        imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=400',
      ),
      PromoCode(
        id: '5',
        code: 'FLASH50',
        title: 'عرض فلاش - خصم 50%',
        description: 'عرض محدود! خصم 50% على طلبك',
        type: PromoType.percentage,
        value: 50,
        minOrderAmount: 2000,
        expiryDate: DateTime.now().add(const Duration(hours: 6)),
        isExclusive: true,
        imageUrl: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=400',
      ),
    ];

    state = state.copyWith(
      promoCodes: mockPromoCodes,
      isLoading: false,
    );
  }

  /// Apply promo code
  bool applyPromoCode(String code, double orderAmount) {
    final promo = state.promoCodes.firstWhere(
      (p) => p.code.toUpperCase() == code.toUpperCase(),
      orElse: () => PromoCode(
        id: '',
        code: '',
        title: '',
        description: '',
        type: PromoType.percentage,
        value: 0,
      ),
    );

    // Check if promo exists
    if (promo.id.isEmpty) {
      state = state.copyWith(error: 'كود الخصم غير صحيح');
      return false;
    }

    // Check if promo is active
    if (!promo.isActive) {
      state = state.copyWith(error: 'كود الخصم منتهي الصلاحية');
      return false;
    }

    // Check minimum order amount
    if (promo.minOrderAmount != null && orderAmount < promo.minOrderAmount!) {
      state = state.copyWith(
        error: 'الحد الأدنى للطلب ${promo.minOrderAmount!.toInt()} دج',
      );
      return false;
    }

    // Apply promo
    state = state.copyWith(appliedPromo: promo, error: null);
    return true;
  }

  /// Remove applied promo
  void removePromo() {
    state = state.copyWith(clearAppliedPromo: true);
  }

  /// Calculate discount amount
  double calculateDiscount(double orderAmount) {
    if (state.appliedPromo == null) return 0;

    final promo = state.appliedPromo!;

    switch (promo.type) {
      case PromoType.percentage:
        return orderAmount * (promo.value / 100);
      case PromoType.fixed:
        return promo.value;
      case PromoType.freeDelivery:
        return 0; // Handled separately in delivery fee
    }
  }

  /// Refresh promo codes
  Future<void> refresh() async {
    _loadPromoCodes();
  }
}

/// Promo provider
final promoProvider = StateNotifierProvider<PromoNotifier, PromoState>((ref) {
  return PromoNotifier();
});
