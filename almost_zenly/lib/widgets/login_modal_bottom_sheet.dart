import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class LoginModalBottomSheet extends StatefulWidget {
  const LoginModalBottomSheet({super.key});

  @override
  State<LoginModalBottomSheet> createState() => _LoginModalBottomSheetState();
}

class _LoginModalBottomSheetState extends State<LoginModalBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final MyClass myClass = MyClass(10, 'hello');
    return Container(
      child: Column(
        children: [],
      ),
    );
  }
}

class MyClass {
  // フィールド
  int _a;
  String _b;

  // ゲッター
  int get a => _a;
  String get b => _b;

  // セッター
  set a(int value) => _a = value;
  set b(String value) => _b = value;

  // コンストラクタ
  // 引数がそのままフィールドに代入される
  MyClass(this._a, this._b);

  // メソッド
  void printValues() {
    print('a = $_a, b = $_b');
  }

  // staticメンバ
  static int myInt = 10;
  static void myFunc() {
    print(myInt);
  }
}
