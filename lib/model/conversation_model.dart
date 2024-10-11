class Conversation {
  final String botMessage;
  final String humanMessage;

  Conversation({required this.botMessage, required this.humanMessage});

  // Factory constructor to create a Conversation instance from JSON data
  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      botMessage: json['bot'] as String,
      humanMessage: json['human'] as String,
    );
  }
}
