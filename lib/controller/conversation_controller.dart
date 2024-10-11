import '../model/conversation_model.dart';

class ConversationController {
  final List<Conversation> _conversations = [];

  // Add a new conversation to the history
  void addConversation(String botMessage, String humanMessage) {
    _conversations
        .add(Conversation(botMessage: botMessage, humanMessage: humanMessage));
  }

  // Get the list of conversations
  List<Conversation> getConversations() {
    return _conversations;
  }

  // Reset conversation history
  void resetConversations() {
    _conversations.clear();
  }

  // Get the expected human response for the next conversation
  String getExpectedResponse(int index) {
    if (index < _conversations.length) {
      return _conversations[index].humanMessage;
    }
    return '';
  }

  // Mock function to simulate the bot's next message
  String getNextBotMessage(int index) {
    if (index < _conversations.length) {
      return _conversations[index].botMessage;
    }
    return 'Conversation ended.';
  }
}
