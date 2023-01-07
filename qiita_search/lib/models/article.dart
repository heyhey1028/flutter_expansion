import 'package:qiita_search/models/user.dart';

class Article {
  final String title;
  final String url;
  final User user;
  final String body;

  Article({
    required this.title,
    required this.url,
    required this.user,
    required this.body,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'],
      url: json['url'],
      user: User.fromJson(json['user']),
      body: json['rendered_body'],
    );
  }
}
