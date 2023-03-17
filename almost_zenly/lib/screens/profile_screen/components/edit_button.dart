import 'package:almost_zenly/models/app_user.dart';
import 'package:almost_zenly/screens/profile_screen/edit_profile_screen.dart';
import 'package:flutter/material.dart';

class EditButton extends StatelessWidget {
  const EditButton({
    super.key,
    required this.appUser,
  });

  final AppUser appUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: double.infinity,
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              return EditProfileScreen(user: appUser);
            }),
          );
        },
        child: const Text(
          '編集',
          style: TextStyle(
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}
