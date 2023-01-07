import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:qiita_search/screens/home_screen.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Qiita Search',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const HomeScreen(title: 'Qiita Search'),
    );
  }
}
