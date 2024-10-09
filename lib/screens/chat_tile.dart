import 'package:flutter/material.dart';

class ChatTile extends StatelessWidget {
  const ChatTile({
    super.key,
    required this.name,
    required this.time,
    required this.message,
  });
  final String name;
  final String message;
  final String time;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 25.0,
        backgroundColor: Colors.lightBlueAccent,
      ),
      title: Text(name),
      subtitle: Text(message),
      onTap: () {},
    );
  }
}
