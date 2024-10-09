import 'package:flutter/material.dart';

import 'chat_tile.dart';

class DashBoard extends StatelessWidget {
  DashBoard({super.key});
  final List<Map<String, dynamic>> chatData = [
    {"name": "John Doe", "message": "Hey! How's it going?", "time": "12:30 PM"},
    {"name": "Jane Smith", "message": "See you tomorrow!", "time": "11:45 AM"},
    {"name": "David Brown", "message": "Can you call me?", "time": "10:15 AM"},
    {
      "name": "Lucy Grey",
      "message": "Let's catch up soon.",
      "time": "Yesterday"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
      ),
      body: ListView.builder(
        itemCount: chatData.length,
        itemBuilder: (context, index) {
          return ChatTile(
            name: chatData[index]["name"],
            message: chatData[index]["message"],
            time: chatData[index]["time"],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.lightBlueAccent,
        child: Icon(
          Icons.message,
          color: Colors.white,
        ),
      ),
    );
  }
}
