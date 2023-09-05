class ChatMessage {
  const ChatMessage({
    this.id,
    required this.roomId,
    required this.message,
    required this.sender,
    required this.createdAt,
  });

  final String? id;
  final String roomId;
  final String message;
  final Sender sender;
  final DateTime createdAt;

  // fromJson method
  factory ChatMessage.fromJson(dynamic json) {
    return ChatMessage(
      id: json['message_id'] as String,
      roomId: json['room_id'] as String,
      message: json['message'] as String,
      sender: json['sent_by_bot'] == false ? Sender.user : Sender.bot,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'message_id': id,
      'room_id': roomId,
      'message': message,
      'sent_by_bot': sender == Sender.bot,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // toApiJson method
  Map<String, dynamic> toApiJson() {
    return {
      "role": sender == Sender.user ? "user" : "assistant",
      "content": message,
    };
  }
}

enum Sender {
  user,
  bot;
}
