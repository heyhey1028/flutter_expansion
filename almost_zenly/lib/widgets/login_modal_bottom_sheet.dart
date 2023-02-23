import 'package:flutter/material.dart';

class LoginModalBottomSheet extends StatefulWidget {
  const LoginModalBottomSheet({super.key});

  @override
  State<LoginModalBottomSheet> createState() => _LoginModalBottomSheetState();
}

class _LoginModalBottomSheetState extends State<LoginModalBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 500,
      child: Column(
        children: const [
          TextField(),
          SizedBox(height: 16),
          TextField(),
        ],
      ),
    );
  }
}
