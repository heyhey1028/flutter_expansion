import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.radius = 40,
  });

  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.transparent,
      backgroundImage: const AssetImage('images/gs.png'),
      radius: radius,
    );
  }
}
