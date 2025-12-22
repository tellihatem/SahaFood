import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/models.dart';

/// Chat state class
/// Holds the current state of order chat
class ChatState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? error;

  const ChatState({
    required this.messages,
    this.isLoading = false,
    this.error,
  });

  /// Initial state with mock messages
  factory ChatState.initial() {
    return ChatState(
      messages: [
        ChatMessage(
          id: '1',
          message: 'مرحباً، طلبك في الطريق إليك',
          sender: MessageSender.driver,
          timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
          isRead: true,
        ),
        ChatMessage(
          id: '2',
          message: 'شكراً، كم المدة المتوقعة؟',
          sender: MessageSender.user,
          timestamp: DateTime.now().subtract(const Duration(minutes: 9)),
          isRead: true,
        ),
        ChatMessage(
          id: '3',
          message: 'سأصل خلال 10 دقائق تقريباً',
          sender: MessageSender.driver,
          timestamp: DateTime.now().subtract(const Duration(minutes: 8)),
          isRead: true,
        ),
      ],
    );
  }

  /// Create a copy with modified fields
  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    String? error,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Chat notifier - manages chat state
/// Follows architecture rules: business logic separated from UI
class ChatNotifier extends StateNotifier<ChatState> {
  ChatNotifier() : super(ChatState.initial());

  /// Load chat messages
  /// In production: Fetch from API or WebSocket
  Future<void> loadMessages(String orderId) async {
    state = state.copyWith(isLoading: true);
    
    try {
      // TODO: Replace with actual API call or WebSocket
      // final messages = await _chatApiService.getMessages(orderId);
      
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Using mock data for now
      final messages = ChatState.initial().messages;
      
      state = state.copyWith(
        messages: messages,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Send message
  /// In production: Send via API or WebSocket
  Future<bool> sendMessage(String orderId, String message) async {
    if (message.trim().isEmpty) return false;
    
    try {
      // TODO: Replace with actual API call or WebSocket
      // await _chatApiService.sendMessage(orderId, message);
      
      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      final newMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        message: message,
        sender: MessageSender.user,
        timestamp: DateTime.now(),
        isRead: false,
      );
      
      final updatedMessages = [...state.messages, newMessage];
      state = state.copyWith(messages: updatedMessages);
      
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// Mark messages as read
  /// In production: Call API endpoint
  Future<void> markAsRead() async {
    try {
      // TODO: Replace with actual API call
      // await _chatApiService.markAsRead();
      
      final updatedMessages = state.messages.map((msg) {
        return msg.copyWith(isRead: true);
      }).toList();
      
      state = state.copyWith(messages: updatedMessages);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

/// Chat provider - exposes chat state to UI
final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  return ChatNotifier();
});
