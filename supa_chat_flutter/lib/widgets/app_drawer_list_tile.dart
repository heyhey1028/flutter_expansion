import 'package:flutter/material.dart';
import 'package:supa_chat_flutter/widgets/chat_room_edit_dialog.dart';

import '../models/chat_room.dart';
import '../pages/chat_page.dart';

class AppDrawerListTile extends StatelessWidget {
  const AppDrawerListTile({
    super.key,
    required this.room,
  });

  final ChatRoom room;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.comment),
      title: Text(room.name),
      onTap: () {
        // チャットページを差し替える
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ChatPage(room: room),
          ),
        );
      },
      trailing: IconButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return ChatRoomEditDialog(room: room);
            },
          );
        },
        icon: const Icon(Icons.edit),
      ),
    );
  }
}
