import 'package:flutter/material.dart';
import 'package:supa_chat_flutter/widgets/app_drawer.dart';
import 'package:supa_chat_flutter/widgets/message_text_field.dart';

import '../widgets/message_list.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    super.key,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Page'),
      ),
      drawer: const AppDrawer(),
      body: const Column(
        children: [
          Expanded(
            child: MessageList(),
          ),
          MessageTextField(),
        ],
      ),
    );
  }
}
