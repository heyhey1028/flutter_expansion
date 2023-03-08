import 'package:almost_zenly/components/app_loading.dart';
import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({
    super.key,
    required this.labelName,
    required this.onTap,
    this.isLoading = false,
  });

  final String labelName;
  final VoidCallback onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      height: 40,
      child: ElevatedButton(
        onPressed: onTap,
        child: isLoading ? const AppLoading() : Text(labelName),
      ),
    );
  }
}
