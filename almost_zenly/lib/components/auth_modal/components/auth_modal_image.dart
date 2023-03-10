import 'package:flutter/material.dart';

class AuthModalImage extends StatelessWidget {
  const AuthModalImage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 300,
      child: Image.asset('assets/images/globe.png'),
    );
  }
}
