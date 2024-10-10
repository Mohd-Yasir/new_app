import 'package:flutter/material.dart';
import 'conversatoin_screen.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sivi Inter Assignment'),
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
                    child: Icon(Icons.chat, color: Colors.deepPurple[300]),
                    radius: 20.0,
                  ),
                ),
              ),
              title: Text("Chat 1", style: TextStyle(fontSize: 18)),
              subtitle: Text("Start chatting with the bot"),
              onTap: () {
                // Navigate to conversation screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ConversationScreen()),
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
            MaterialPageRoute(builder: (context) => ConversationScreen()),
          );
          // You can implement other chat options or functionality here
        },
        child: Icon(Icons.add),
        tooltip: 'Add new chat',
      ),
    );
  }
}
