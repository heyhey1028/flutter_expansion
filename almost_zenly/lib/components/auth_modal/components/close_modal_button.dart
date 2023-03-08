import 'package:flutter/material.dart';

class CloseModalButton extends StatelessWidget {
  const CloseModalButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.centerLeft,
      child: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.close),
      ),
    );
  }
}
