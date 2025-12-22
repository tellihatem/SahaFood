/// Banner provider for promotional carousels
/// Follows architecture rules: Riverpod, immutable state, local data

import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/models.dart';

/// Banner state class
class BannerState {
  final List<PromoBanner> banners;
  final bool isLoading;
  final String? error;

  const BannerState({
    this.banners = const [],
    this.isLoading = false,
    this.error,
  });

  BannerState copyWith({
    List<PromoBanner>? banners,
    bool? isLoading,
    String? error,
  }) {
    return BannerState(
      banners: banners ?? this.banners,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

/// Banner notifier
class BannerNotifier extends StateNotifier<BannerState> {
  BannerNotifier() : super(const BannerState()) {
    _loadBanners();
  }

  /// Load banners (mock data - replace with API call later)
  void _loadBanners() {
    state = state.copyWith(isLoading: true);

    // Mock data - in production, this would be an API call
    final mockBanners = [
      const PromoBanner(
        id: '1',
        title: 'خصم 30%',
        subtitle: 'على طلبك الأول',
        imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800',
        type: BannerType.discount,
      ),
      const PromoBanner(
        id: '2',
        title: 'توصيل مجاني',
        subtitle: 'لجميع الطلبات فوق 500 دج',
        imageUrl: 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=800',
        type: BannerType.promotion,
      ),
      const PromoBanner(
        id: '3',
        title: 'مطاعم جديدة',
        subtitle: 'اكتشف أفضل المطاعم',
        imageUrl: 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800',
        type: BannerType.newRestaurant,
      ),
    ];

    state = state.copyWith(
      banners: mockBanners,
      isLoading: false,
    );
  }

  /// Refresh banners
  Future<void> refresh() async {
    _loadBanners();
  }
}

/// Banner provider
final bannerProvider = StateNotifierProvider<BannerNotifier, BannerState>((ref) {
  return BannerNotifier();
});
