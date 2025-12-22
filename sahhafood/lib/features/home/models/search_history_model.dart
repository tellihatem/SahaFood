/// Search history model for home feature
/// Follows architecture rules: immutable, copyWith pattern, backend-ready

class SearchHistory {
  final String id;
  final String query;
  final DateTime timestamp;

  const SearchHistory({
    required this.id,
    required this.query,
    required this.timestamp,
  });

  /// Create a copy with modified fields
  SearchHistory copyWith({
    String? id,
    String? query,
    DateTime? timestamp,
  }) {
    return SearchHistory(
      id: id ?? this.id,
      query: query ?? this.query,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  /// Create from JSON (for API integration)
  factory SearchHistory.fromJson(Map<String, dynamic> json) {
    return SearchHistory(
      id: json['id'] as String,
      query: json['query'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  /// Convert to JSON (for API integration)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'query': query,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
