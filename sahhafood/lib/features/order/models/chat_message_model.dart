/// Chat message model for order chat
/// Follows architecture rules: immutable, backend-ready

enum MessageSender {
  user,
  driver;

  String get displayName {
    switch (this) {
      case MessageSender.user:
        return 'أنت';
      case MessageSender.driver:
        return 'السائق';
    }
  }
}

class ChatMessage {
  final String id;
  final String message;
  final MessageSender sender;
  final DateTime timestamp;
  final bool isRead;

  const ChatMessage({
    required this.id,
    required this.message,
    required this.sender,
    required this.timestamp,
    this.isRead = false,
  });

  /// Create a copy with modified fields
  ChatMessage copyWith({
    String? id,
    String? message,
    MessageSender? sender,
    DateTime? timestamp,
    bool? isRead,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      message: message ?? this.message,
      sender: sender ?? this.sender,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
    );
  }

  /// Create from JSON (for API integration)
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      message: json['message'] as String,
      sender: MessageSender.values.firstWhere(
        (e) => e.name == json['sender'],
        orElse: () => MessageSender.user,
      ),
      timestamp: DateTime.parse(json['timestamp'] as String),
      isRead: json['is_read'] as bool? ?? false,
    );
  }

  /// Convert to JSON (for API integration)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'sender': sender.name,
      'timestamp': timestamp.toIso8601String(),
      'is_read': isRead,
    };
  }
}
