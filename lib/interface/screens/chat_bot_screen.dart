// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../custom/widgets/chat_message_widget.dart';
import '../custom/widgets/send_message_field_widget.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  List<ChatMessage> messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return messages[index];
              },
            ),
          ),
          SendMessageField(
            onMessageSent: (message) {
              setState(() {
                messages.add(ChatMessage(
                  message: message,
                  isMe: true,
                ));
              });
            },
          ),
        ],
      ),
    );
  }
}
