import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants.dart';

class ChatMessage extends StatelessWidget {
  final String message;
  final bool isMe;

  const ChatMessage({
    required this.message,
    required this.isMe,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: isMe ? kGrey : Colors.grey[300],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(24.0),
            topRight: const Radius.circular(24.0),
            bottomLeft: isMe ? const Radius.circular(24.0) : const Radius.circular(0),
            bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(24.0),
          ),
        ),
        constraints: BoxConstraints(maxWidth:MediaQuery.of(context).size.width * 0.66),
        child: Text(
          message,
          style: GoogleFonts.raleway(
            color: isMe ? Colors.white : kGrey,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}