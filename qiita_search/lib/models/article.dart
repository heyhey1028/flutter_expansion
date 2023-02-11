import 'package:qiita_search/models/user.dart';

class Article {
  final String title;
  final User user;
  final String url;
  final String body;
  final int likesCount;
  final List<String> tags;
  final DateTime createdAt;

  Article({
    required this.title,
    required this.user,
    required this.url,
    required this.body,
    required this.createdAt,
    this.likesCount = 0,
    this.tags = const [],
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'],
      url: json['url'],
      user: User.fromJson(json['user']),
      body: json['body'],
      createdAt: DateTime.parse(json['created_at'].toString()),
      likesCount: json['likes_count'],
      tags: List<String>.from(json['tags'].map((tag) => tag['name'])),
    );
  }
}
