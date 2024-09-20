// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:myapp/services/gemini_service.dart';
import '../custom/widgets/chat_message_widget.dart';
import '../custom/widgets/send_message_field_widget.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  List<ChatMessage> messages = [];
  final ScrollController _scrollController = ScrollController();

  final GeminiService _geminiService = GeminiService();

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _sendMessage(String message) async {
    setState(() {
      messages.add(ChatMessage(
        message: message,
        isMe: true,
      ));
    });
    _scrollToBottom(); // Scroll to the bottom when a new message is added

    String? response = await _geminiService
        .generateContent(Content('user', [TextPart(message)]));

    try {
      if (response != null) {
        setState(() {
          messages.add(ChatMessage(
            message: response,
            isMe: false,
          ));
        });
        _scrollToBottom();
      }
    } on Exception catch (e) {
      messages.add(ChatMessage(message: 'Error: $e', isMe: false));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16.0),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return messages[index];
              },
            ),
          ),
          SendMessageField(
            onMessageSent: _sendMessage,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
