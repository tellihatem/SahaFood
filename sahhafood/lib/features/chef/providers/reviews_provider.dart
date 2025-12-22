import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';

/// Reviews state
class ReviewsState {
  final List<Review> reviews;

  ReviewsState({
    this.reviews = const [],
  });

  ReviewsState copyWith({
    List<Review>? reviews,
  }) {
    return ReviewsState(
      reviews: reviews ?? this.reviews,
    );
  }

  /// Get average rating
  double get averageRating {
    if (reviews.isEmpty) return 0.0;
    final sum = reviews.fold<double>(0.0, (sum, review) => sum + review.rating);
    return sum / reviews.length;
  }

  /// Get reviews count by rating
  Map<int, int> get ratingDistribution {
    final distribution = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    for (final review in reviews) {
      final rating = review.rating.round();
      distribution[rating] = (distribution[rating] ?? 0) + 1;
    }
    return distribution;
  }
}

/// Reviews provider with state management
class ReviewsNotifier extends StateNotifier<ReviewsState> {
  ReviewsNotifier() : super(ReviewsState()) {
    _initializeMockData();
  }

  /// Initialize with mock data for development
  void _initializeMockData() {
    final mockReviews = [
      Review(
        id: '1',
        customerName: 'أحمد محمد',
        rating: 5.0,
        comment: 'طعام رائع وخدمة ممتازة! سأطلب مرة أخرى بالتأكيد.',
        date: DateTime.now().subtract(const Duration(hours: 2)),
        orderId: '#1230',
      ),
      Review(
        id: '2',
        customerName: 'فاطمة الزهراء',
        rating: 4.5,
        comment: 'الطعم جيد جداً والتوصيل كان سريعاً.',
        date: DateTime.now().subtract(const Duration(hours: 5)),
        orderId: '#1228',
      ),
      Review(
        id: '3',
        customerName: 'محمد علي',
        rating: 5.0,
        comment: 'أفضل كسكس جربته! شكراً لكم.',
        date: DateTime.now().subtract(const Duration(days: 1)),
        orderId: '#1220',
      ),
      Review(
        id: '4',
        customerName: 'سارة حسن',
        rating: 4.0,
        comment: 'جيد ولكن التوصيل تأخر قليلاً.',
        date: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
        orderId: '#1215',
      ),
      Review(
        id: '5',
        customerName: 'كريم عبدالله',
        rating: 5.0,
        comment: 'ممتاز! الطعام ساخن ولذيذ.',
        date: DateTime.now().subtract(const Duration(days: 2)),
        orderId: '#1210',
      ),
      Review(
        id: '6',
        customerName: 'ليلى يوسف',
        rating: 4.5,
        comment: 'طعام رائع ونظيف. شكراً.',
        date: DateTime.now().subtract(const Duration(days: 3)),
        orderId: '#1205',
      ),
    ];

    state = state.copyWith(reviews: mockReviews);
  }

  /// Add new review (from completed order)
  void addReview(Review review) {
    state = state.copyWith(reviews: [review, ...state.reviews]);
  }

  /// Get recent reviews (last n reviews)
  List<Review> getRecentReviews(int count) {
    return state.reviews.take(count).toList();
  }
}

/// Provider instance
final reviewsProvider = StateNotifierProvider<ReviewsNotifier, ReviewsState>((ref) {
  return ReviewsNotifier();
});
