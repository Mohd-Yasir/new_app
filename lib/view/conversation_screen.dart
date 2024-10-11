import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../controller/conversation_controller.dart';
import 'package:http/http.dart' as http;

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key});

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  String writtenText = ''; // To store text input
  final ConversationController _controller = ConversationController();
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  bool _isListening = false;
  String _userSpeech = "";
  int _currentMessageIndex = 0; // To keep track of the conversation
  int _attempts = 0; // To track the number of attempts
  bool _isLoading = true; // To show a loading state while fetching API data
  final TextEditingController messageTextController =
      TextEditingController(); // Controller for the TextField
  final ScrollController _scrollController =
      ScrollController(); // Scroll controller for ListView

  @override
  void initState() {
    super.initState();
    _fetchConversations(); // Fetch conversations from API
  }

  // Fetch conversations from API
  Future<void> _fetchConversations() async {
    const String apiUrl =
        'https://my-json-server.typicode.com/tryninjastudy/dummyapi/db'; // API URL
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // If the server returns an OK response, parse the JSON
        final data = jsonDecode(response.body);
        List<dynamic> conversations = data['restaurant'];

        // Add conversations to the controller
        for (var conversation in conversations) {
          _controller.addConversation(
              conversation['bot'], conversation['human']);
        }

        // Show the first bot message "Hello"
        _sendBotMessage("Hello");
      } else {
        throw Exception('Failed to load conversations');
      }
    } catch (e) {
      print('Error fetching conversations: $e');
    } finally {
      setState(() {
        _isLoading = false; // Stop loading after data is fetched
      });
    }
  }

  // Add the bot's message to the conversation
  void _sendBotMessage(String message) {
    setState(() {
      _controller.addConversation(
          message, ""); // Add bot message to conversation
    });
    // Scroll to bottom after UI is updated
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  // Start listening to user's speech
  void _startListening() async {
    bool available = await _speechToText
        .initialize(); // Initialize the speech-to-text functionality
    if (available) {
      setState(() => _isListening = true); // Set listening flag to true
      _speechToText.listen(onResult: (val) {
        setState(() {
          _userSpeech =
              val.recognizedWords; // Update _userSpeech with recognized speech
        });
      });
    } else {
      print('Speech recognition not available');
    }
  }

  // Stop listening to user's speech
  void _stopListening() {
    if (_isListening) {
      _speechToText.stop(); // Stop listening when mic is turned off
      setState(() => _isListening = false);

      // Process the speech result when speech stops
      if (_userSpeech.isNotEmpty) {
        _processUserSpeech(
            _userSpeech); // Send the speech input to be processed
        _userSpeech = ""; // Reset after sending
      }
    }
  }

  // Process the user's input (text or speech)
  void _processUserSpeech(String userSpeech) {
    String expectedResponse =
        _controller.getExpectedResponse(_currentMessageIndex);

    // Remove punctuation from both the user speech and expected response
    String cleanedUserSpeech = _removePunctuation(userSpeech.toLowerCase());
    String cleanedExpectedResponse =
        _removePunctuation(expectedResponse.toLowerCase());
    // Add the user's message to the conversation (correct or incorrect)
    _controller.addConversation("", userSpeech); // Add user's input to chat

    // Check if the user's response matches the expected response
    if (cleanedUserSpeech == cleanedExpectedResponse) {
      _currentMessageIndex++;
      _attempts = 0; // Reset attempts after a correct answer

      // Send the next bot message
      _sendBotMessage(_controller.getNextBotMessage(_currentMessageIndex));

      setState(() {
        // UI will be updated to show both user's correct input and bot's next message
      });
    } else {
      // Increment attempts count for incorrect answers
      _attempts++;
      // Add incorrect response to conversation history
      if (_attempts == 1 && userSpeech.isNotEmpty) {
        _controller.addConversation(
            "Sorry, I didn't understand: $userSpeech", "");
      }

      if (_attempts == 2 && userSpeech.isNotEmpty) {
        // First incorrect attempt: show the correct response
        _controller.addConversation(
            "The correct response was: $expectedResponse", "");

        setState(() {
          // UI updated to show correct response
        });
      } else if (_attempts == 3 && userSpeech.isNotEmpty) {
        _currentMessageIndex++;
        _attempts = 0; // Reset attempts after skipping

        _sendBotMessage(_controller.getNextBotMessage(_currentMessageIndex));

        setState(() {
          // UI updated to reflect the skipped message and bot's next message
        });
      }
    }
    // Scroll to bottom after UI is updated
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  // Auto-scroll to the bottom of the ListView
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  String _removePunctuation(String text) {
    // Use RegExp to remove punctuation
    return text.replaceAll(RegExp(r'[^\w\s]'), '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Conversation with Bot')),
      body: Column(
        children: [
          _isLoading
              ? const Center(
                  child:
                      CircularProgressIndicator()) // Show loading indicator while data is being fetched
              : Expanded(
                  child: ListView.builder(
                    controller:
                        _scrollController, // Attach the ScrollController to the ListView
                    itemCount: _controller.getConversations().length,
                    itemBuilder: (context, index) {
                      final conversation =
                          _controller.getConversations()[index];
                      return ListTile(
                        title: Align(
                          alignment: (conversation.humanMessage.isEmpty)
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: conversation.humanMessage.isEmpty
                                  ? Colors.grey[300]
                                  : Colors.blue[100],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              conversation.humanMessage.isEmpty
                                  ? " ${conversation.botMessage}"
                                  : " ${conversation.humanMessage}",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller:
                        messageTextController, // Attach controller to TextField
                    decoration: const InputDecoration(
                      hintText: 'Type your response here...',
                    ),
                    onChanged: (value) {
                      writtenText =
                          value; // Update the writtenText when text changes
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(_isListening ? Icons.mic_off : Icons.mic),
                  onPressed: _isListening
                      ? _stopListening
                      : _startListening, // Handle mic button press
                ),
                IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      if (writtenText.isNotEmpty) {
                        setState(() {
                          messageTextController
                              .clear(); // Clear input after sending
                          _processUserSpeech(
                              writtenText); // Process the written text
                          writtenText = ''; // Clear writtenText after sending
                        });
                      }
                    })
              ],
            ),
          ),
        ],
      ),
    );
  }
}
