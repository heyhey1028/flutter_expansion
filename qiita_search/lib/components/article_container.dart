import 'package:flutter/material.dart';
import 'package:qiita_search/models/article.dart';
import 'package:qiita_search/screens/article_screen.dart';

/// 自由にカスタマイズしてみてください
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
        horizontal: 16,
        vertical: 8,
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: ((context) => ArticleScreen(article: article)),
            ),
          );
        },
        child: Container(
          height: 100,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          decoration: const BoxDecoration(color: Colors.lightGreen),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('title: ${article.title}'),
              Text('user: ${article.user.id}'),
            ],
          ),
        ),
      ),
    );
  }
}
