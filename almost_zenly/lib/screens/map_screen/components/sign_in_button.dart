import 'package:almost_zenly/screens/profile_screen/test_firestore_screen.dart';
import 'package:flutter/material.dart';

class SignInButton extends StatelessWidget {
  const SignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) {
            return const TestFirestoreScreen();
          },
        ));
        // showModalBottomSheet(
        //     context: context,
        //     isScrollControlled: true,
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(16.0),
        //     ),
        //     builder: (BuildContext context) {
        //       return const AuthModal();
        //     });
      },
      label: const Text('SIGN IN'),
    );
  }
}
