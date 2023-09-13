import 'package:flutter/material.dart';

import '../models/chat_room.dart';

class ChatRoomEditDialog extends StatefulWidget {
  const ChatRoomEditDialog({
    super.key,
    required this.room,
  });

  final ChatRoom room;

  @override
  State<ChatRoomEditDialog> createState() => _ChatRoomEditDialogState();
}

class _ChatRoomEditDialogState extends State<ChatRoomEditDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.room.name);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Chat Room'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          labelText: 'Chat Room Name',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
