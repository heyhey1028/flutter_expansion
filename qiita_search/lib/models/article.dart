import 'package:qiita_search/models/user.dart';

class Article {
  final String title;
  final User user;
  final String url;
  final DateTime createdAt;
  final int likesCount;
  final List<String> tags;

  Article({
    required this.title,
    required this.user,
    required this.url,
    required this.createdAt,
    this.likesCount = 0,
    this.tags = const [],
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'],
      user: User.fromJson(json['user']),
      url: json['url'],
      createdAt: DateTime.parse(json['created_at'].toString()),
      likesCount: json['likes_count'],
      tags: List<String>.from(json['tags'].map((tag) => tag['name'])),
    );
  }
}
