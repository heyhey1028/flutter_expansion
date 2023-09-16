import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.room.name);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Chat Room'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Chat Room Name',
            ),
          ),
          if (errorMessage.isNotEmpty)
            Text(
              errorMessage,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
        ],
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
            final result = await updateChatRoom(
              roomId: widget.room.id!,
              newName: _controller.text,
            );
            if (context.mounted && result != null) Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }

  Future<ChatRoom?> updateChatRoom({
    required String roomId,
    required String newName,
  }) async {
    try {
      final result = await Supabase.instance.client.from('chat_rooms').update({'room_name': newName}).eq('room_id', roomId).select();
      return ChatRoom.fromJson(result.first);
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
      return null;
    }
  }
}
