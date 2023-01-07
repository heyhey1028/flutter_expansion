import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:qiita_search/components/article_container.dart';
import 'dart:convert' as convert;

import 'package:qiita_search/models/article.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchText = '';
  List<Article> articles = [];
  late TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 36,
            ),
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter search keyword',
              ),
              onChanged: (value) {
                setState(() => searchText = value);
              },
              onSubmitted: ((value) async {
                final result = await searchQiita(value);

                setState(() => articles = result);
              }),
            ),
          ),
          Expanded(
            child: ListView(
              children: articles
                  .map((article) => ArticleContainer(article: article))
                  .toList(),
            ),
          )
        ],
      ),
    );
  }

  Future<List<Article>> searchQiita(String keyword) async {
    final String token = dotenv.env['QIITA_API_TOKEN'] ?? '';
    final url = Uri.https('qiita.com', '/api/v2/items', {
      'query': 'title:$keyword',
      'per_page': '5',
    });

    final res = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });

    if (res.statusCode == 200) {
      List<dynamic> jsonResponse = convert.jsonDecode(res.body);
      return jsonResponse.map((json) => Article.fromJson(json)).toList();
    } else {
      return [];
    }
  }
}
