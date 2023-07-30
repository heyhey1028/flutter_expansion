import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
        height: 180, // 高さを指定
        padding: const EdgeInsets.symmetric(
          // 内側の余白を指定
          horizontal: 20,
          vertical: 16,
        ),
        decoration: const BoxDecoration(
          color: Color(0xFF55C500), // 背景色を指定
          borderRadius: BorderRadius.all(
            Radius.circular(32), // 角丸を設定
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 投稿日
            Text(
              DateFormat('yyyy/MM/dd').format(article.createdAt),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
            // タイトル
            Text(
              article.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            // タグ
            Text(
              '#${article.tags.join(' #')}',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontStyle: FontStyle.italic,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // ハートアイコンといいね数
                Column(
                  children: [
                    const Icon(
                      Icons.favorite,
                      color: Colors.white,
                    ),
                    Text(
                      article.likesCount.toString(),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                // 投稿者のアイコンと投稿者名
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundImage: NetworkImage(article.user.profileImageUrl),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      article.user.id,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
