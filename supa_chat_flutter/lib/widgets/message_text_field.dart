import 'package:flutter/material.dart';

class MessageTextField extends StatefulWidget {
  const MessageTextField({super.key});

  @override
  State<MessageTextField> createState() => _MessageTextFieldState();
}

class _MessageTextFieldState extends State<MessageTextField> {
  // テキスト入力欄のコントローラー
  final messageController = TextEditingController();
  // フィールドに入力があるかどうかを管理するフラグ
  bool isTyping = false;
  // リスナー破棄の関数を代入する変数
  late VoidCallback _removeListener;

  @override
  void initState() {
    // controllerの入力に応じて発火する処理を定義
    void listener() => setState(() => isTyping = messageController.text.isNotEmpty);
    // 上記処理をリスナーとして登録
    messageController.addListener(listener);
    // リスナーを破棄する処理を代入
    _removeListener = () => messageController.removeListener(listener);
    super.initState();
  }

  @override
  void dispose() {
    // コントローラーを破棄
    messageController.dispose();
    // リスナーを破棄
    _removeListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // 余白を設定
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      // 背景色を設定
      color: Colors.black87,
      // テキスト入力欄と送信ボタンを横並びにする
      child: Row(
        children: [
          Expanded(
            child: TextField(
              // コントローラーを設定
              controller: messageController,
              // テキスト入力欄の文字色
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                // フォーカス前の枠線
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(16),
                  ),
                ),
                // フォーカス時の枠線
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(16),
                  ),
                ),
                hintText: 'Send a message',
                hintStyle: TextStyle(color: Colors.white),
                // カウンターの文字色
                counterStyle: TextStyle(color: Colors.white),
              ),
              // 文字数制限
              // maxLength: 280,
              // 最低行数、最大行数を指定
              minLines: 1,
              maxLines: 4,
              // 画面外タップでフォーカスを外す
              onTapOutside: (event) => FocusScope.of(context).unfocus(),
            ),
          ),
          GestureDetector(
            onTap: () {
              // TODO:メッセージ送信処理を後ほど追加

              // 送信後、入力欄を空にする
              messageController.clear();
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              // margin: const EdgeInsets.only(left: 8, bottom: 20),

              // 入力中の場合、背景色を付ける
              decoration: isTyping
                  ? BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8),
                    )
                  : null,
              // 入力中の場合、ボタンの色を変える
              child: Icon(
                Icons.send,
                color: isTyping ? Colors.white : Colors.grey[400],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
