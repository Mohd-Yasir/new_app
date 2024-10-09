import 'package:flutter/material.dart';
import 'package:new_app/api_calls/previous_chats.dart';
import 'package:speech_to_text/speech_to_text.dart';

class ConversationPage extends StatefulWidget {
  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  final ApiService apiService = ApiService();
  late Future<List<Map<String, String>>> conversations;

  @override
  void initState() {
    super.initState();
    conversations = apiService.fetchConv();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.lightBlueAccent,
            title: const Text(
              'Conversation Page',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: Container(
                  child: FutureBuilder<List<Map<String, String>>>(
                      future: conversations,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error ${snapshot.error}'));
                        } else if (snapshot.hasData) {
                          List<Map<String, String>> conversationData =
                              snapshot.data!;
                          return ListView.builder(
                              itemCount: conversationData.length,
                              itemBuilder: (context, index) {
                                final conversation = conversationData[index];
                                return ListTile(
                                  title: Text('Bot ${conversation['bot']}'),
                                  subtitle:
                                      Text('Human ${conversation['human']}'),
                                );
                              });
                        } else {
                          return const Center(
                            child: Text('No Conversation availabe.'),
                          );
                        }
                      }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide.none,
                          ),
                          hintText: 'Type a message',
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.mic,
                                    color: Colors.black,
                                  )),
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.send,
                                    color: Colors.black,
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
