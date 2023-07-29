import 'package:flutter/material.dart';

class ArticleContainer extends StatelessWidget {
  const ArticleContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180, // ← 高さを指定
      decoration: const BoxDecoration(
        color: Color(0xFF55C500), // ← 背景色を指定
        borderRadius: BorderRadius.all(
          // ← 角丸を設定
          Radius.circular(32),
        ),
      ),
    );
  }
}
