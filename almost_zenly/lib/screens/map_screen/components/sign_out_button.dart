import 'package:flutter/material.dart';

class SignOutButton extends StatelessWidget {
  const SignOutButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      child: const Icon(Icons.logout),
    );
  }
}
