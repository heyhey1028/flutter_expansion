import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/chat_message.dart';
import 'message_bubble.dart';

class MessageList extends StatelessWidget {
  const MessageList({
    super.key,
    required this.roomId,
  });

  final String? roomId;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: const BoxDecoration(
        image: DecorationImage(
          opacity: 0.1,
          image: AssetImage('images/gs.png'),
        ),
      ),
      child: StreamBuilder(
        stream: getMessageStream(roomId),
        builder: (context, AsyncSnapshot snapshot) {
          // エラーが発生した場合
          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }

          // データが取得できた場合
          final messages = snapshot.data ?? [];
          return ListView(
            reverse: true,
            children: [
              for (final message in messages) MessageBubble(message: message),
            ],
          );
        },
      ),
    );
  }

  // Messageストリームを取得する
  Stream<List<ChatMessage>> getMessageStream(String? roomId) {
    if (roomId == null) return const Stream.empty();

    return Supabase.instance.client.from('chat_messages').stream(primaryKey: ['message_id']).eq('room_id', roomId).order('created_at').map(
          (snapshot) {
            return snapshot.map(ChatMessage.fromJson).toList();
          },
        );
  }
}
