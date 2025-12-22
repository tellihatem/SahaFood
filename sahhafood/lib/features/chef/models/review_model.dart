/// Review model - customer reviews for chef/restaurant
class Review {
  final String id;
  final String customerName;
  final String? customerPhotoUrl;
  final double rating;
  final String comment;
  final DateTime date;
  final String? orderId;
  final List<String>? photos; // Optional photos from customer

  Review({
    required this.id,
    required this.customerName,
    this.customerPhotoUrl,
    required this.rating,
    required this.comment,
    required this.date,
    this.orderId,
    this.photos,
  });

  Review copyWith({
    String? id,
    String? customerName,
    String? customerPhotoUrl,
    double? rating,
    String? comment,
    DateTime? date,
    String? orderId,
    List<String>? photos,
  }) {
    return Review(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      customerPhotoUrl: customerPhotoUrl ?? this.customerPhotoUrl,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      date: date ?? this.date,
      orderId: orderId ?? this.orderId,
      photos: photos ?? this.photos,
    );
  }
}
