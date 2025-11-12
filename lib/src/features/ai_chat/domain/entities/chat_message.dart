enum MessageType {
  user,
  bot,
  loading,
  error,
}

class ChatMessage {
  final String id;
  final String text;
  final MessageType type;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.text,
    required this.type,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  // Factory constructor for const when timestamp is provided
  const ChatMessage.withTimestamp({
    required this.id,
    required this.text,
    required this.type,
    required this.timestamp,
  });

  ChatMessage copyWith({
    String? id,
    String? text,
    MessageType? type,
    DateTime? timestamp,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      text: text ?? this.text,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatMessage &&
        other.id == id &&
        other.text == text &&
        other.type == type &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        text.hashCode ^
        type.hashCode ^
        timestamp.hashCode;
  }
}
