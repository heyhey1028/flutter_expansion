import 'package:flutter/material.dart';
import 'package:qiita_search202307/models/article.dart';

class ArticleContainer extends StatelessWidget {
  const ArticleContainer({
    super.key,
    required this.article,
  });

  final Article article;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 16,
      ),
      child: Container(
        height: 180, // ← 高さを指定
        decoration: const BoxDecoration(
          color: Color(0xFF55C500), // ← 背景色を指定
          borderRadius: BorderRadius.all(
            // ← 角丸を設定
            Radius.circular(32),
          ),
        ),
      ),
    );
  }
}
