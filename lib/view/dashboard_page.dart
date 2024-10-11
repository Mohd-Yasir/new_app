import 'package:flutter/material.dart';
import 'conversation_screen.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sivi Intern Assignment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Container(
                width: 50.0,
                height: 50.0,
                decoration: BoxDecoration(
                  color: Colors.deepPurple[300],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20.0,
                    child: Icon(Icons.chat, color: Colors.deepPurple[300]),
                  ),
                ),
              ),
              title: const Text("Chat 1", style: TextStyle(fontSize: 18)),
              subtitle: const Text("Start chatting with the bot"),
              onTap: () {
                // Navigate to conversation screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ConversationScreen()),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ConversationScreen()),
          );
        },
        tooltip: 'Add new chat',
        child: const Icon(Icons.add),
      ),
    );
  }
}
