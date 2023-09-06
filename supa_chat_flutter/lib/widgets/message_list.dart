import 'package:flutter/material.dart';

import '../models/chat_message.dart';
import 'message_bubble.dart';

class MessageList extends StatelessWidget {
  const MessageList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final messages = [
      ChatMessage(
        roomId: '1',
        message: 'これはテストです',
        sender: Sender.user,
        createdAt: DateTime.now(),
      ),
      ChatMessage(
        roomId: '1',
        message: 'これはテストです',
        sender: Sender.bot,
        createdAt: DateTime.now(),
      ),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: const BoxDecoration(
        image: DecorationImage(
          opacity: 0.1,
          image: AssetImage('images/gs.png'),
        ),
      ),
      child: ListView(
        children: [
          for (final message in messages) MessageBubble(message: message),
        ],
      ),
    );
  }
}
