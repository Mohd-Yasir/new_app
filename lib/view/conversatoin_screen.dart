// view/conversation_screen.dart

import 'dart:convert'; // Import for jsonDecode
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../controller/conversation_controller.dart';
import 'package:http/http.dart' as http; // Import for HTTP requests

class ConversationScreen extends StatefulWidget {
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  String writtenText = ''; // To store text input
  final ConversationController _controller = ConversationController();
  stt.SpeechToText _speechToText = stt.SpeechToText();
  bool _isListening = false; // Flag to check if mic is listening
  String _userSpeech = ""; // To store recognized speech
  int _currentMessageIndex = 0; // To keep track of the conversation
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
    final String apiUrl =
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
    _scrollToBottom(); // Auto-scroll after adding a new message
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

    // Check if the user's response matches the expected response
    if (userSpeech.toLowerCase() == expectedResponse.toLowerCase()) {
      _currentMessageIndex++;
      _sendBotMessage(_controller
          .getNextBotMessage(_currentMessageIndex)); // Send next bot message
    } else {
      // Handle incorrect response
      _controller.addConversation("Sorry, I didn't understand.", userSpeech);
      setState(() {}); // Refresh UI to display new message

      // Check if the user failed twice
      if (_currentMessageIndex < _controller.getConversations().length - 1) {
        // Show the correct response after two incorrect attempts
        _controller.addConversation(
            "The correct response was: $expectedResponse", "");
        setState(() {});
      }
    }
    _scrollToBottom(); // Scroll to bottom after processing
  }

  // Auto-scroll to the bottom of the ListView
  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Conversation with Bot')),
      body: Column(
        children: [
          _isLoading
              ? Center(
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
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: conversation.humanMessage.isEmpty
                                  ? Colors.grey[300]
                                  : Colors.blue[100],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              conversation.humanMessage.isEmpty
                                  ? "Bot: ${conversation.botMessage}"
                                  : "You: ${conversation.humanMessage}",
                              style: TextStyle(fontSize: 16),
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
                    decoration: InputDecoration(
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
                    icon: Icon(Icons.send),
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
