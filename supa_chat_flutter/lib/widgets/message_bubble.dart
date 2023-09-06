import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/material.dart';

import '../models/chat_message.dart';
import 'app_logo.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
  });

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (message.sender == Sender.bot) const AppLogo(radius: 15),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: BubbleSpecialThree(
                text: message.message,
                isSender: message.sender == Sender.user,
                color: message.sender == Sender.bot ? Colors.blue : Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
