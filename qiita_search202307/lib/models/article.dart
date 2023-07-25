import 'package:qiita_search202307/models/user.dart';

class Article {
  // コンストラクタ
  Article({
    required this.title,
    required this.user,
    this.likesCount = 0, // デフォルト値を0で設定
    this.tags = const [], // デフォルト値を空配列で設定
    required this.createdAt,
    required this.url,
  });

  // プロパティ
  final String title;
  final User user;
  final int likesCount;
  final List<String> tags;
  final DateTime createdAt;
  final String url;

  // JSONからArticleを生成するファクトリコンストラクタ
  factory Article.fromJson(dynamic json) {
    return Article(
      title: json['title'] as String,
      user: User.fromJson(json['user']), // User.fromJson()を使ってUserを生成
      url: json['url'] as String,
      createdAt: DateTime.parse(json['created_at'] as String), // DateTime.parse()を使って文字列をDateTimeに変換
      likesCount: json['likes_count'] as int,
      tags: List<String>.from(json['tags'].map((tag) => tag['name'])), // List<String>.from()を使ってList<String>に変換
    );
  }
}
