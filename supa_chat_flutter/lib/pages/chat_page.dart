import 'package:flutter/material.dart';
import 'package:supa_chat_flutter/widgets/app_drawer.dart';
import 'package:supa_chat_flutter/widgets/message_text_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/chat_room.dart';
import '../widgets/message_list.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    super.key,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late String userId;
  late ChatRoom room;

  @override
  void initState() {
    userId = Supabase.instance.client.auth.currentUser!.id;
    room = ChatRoom(userId: userId, name: 'New chat', createdAt: DateTime.now());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Page'),
      ),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          Expanded(
            child: MessageList(
              roomId: room.id,
            ),
          ),
          MessageTextField(
            onSubmitted: (message) async {
              // チャットルームがなければ作成
              if (room.id == null) {
                final result = await createChatRoom(context, userId: room.userId, roomName: room.name);
                // チャットルームが作成できたら、roomに代入
                if (result != null) {
                  setState(() {
                    room = result;
                  });
                }
              }

              // メッセージテーブルにレコードを挿入
              if (context.mounted) await sendChatMessage(context, message: message, room: room, fromBot: false);
            },
          ),
        ],
      ),
    );
  }

  Future<ChatRoom?> createChatRoom(
    BuildContext context, {
    required String roomName,
    required String userId,
  }) async {
    try {
      final result = await Supabase.instance.client.from('chat_rooms').insert({
        'room_name': roomName,
        'user_id': userId,
      }).select();
      return ChatRoom.fromJson(result.first);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
      return null;
    }
  }

  Future<void> sendChatMessage(
    BuildContext context, {
    required String message,
    required ChatRoom room,
    required bool fromBot,
  }) async {
    try {
      await Supabase.instance.client.from('chat_messages').insert({
        'room_id': room.id,
        'message': message,
        'sent_by_bot': fromBot,
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
    return;
  }
}
