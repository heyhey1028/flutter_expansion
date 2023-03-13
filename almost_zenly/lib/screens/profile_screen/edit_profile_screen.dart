import 'package:almost_zenly/components/app_loading.dart';
import 'package:almost_zenly/models/app_user.dart';
import 'package:almost_zenly/screens/profile_screen/components/image_type_grid_view.dart';
import 'package:almost_zenly/types/image_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({
    super.key,
    required this.user,
  });

  final AppUser user;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late ImageType selectedImageType;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _profileController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    selectedImageType = widget.user.imageType;
    _nameController.text = widget.user.name;
    _profileController.text = widget.user.profile;
    super.initState();
  }

  void _setImageType(ImageType imageType) {
    setState(() {
      selectedImageType = imageType;
    });
  }

  void _setIsLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ImageTypeGridView(
                      selectedImageType: selectedImageType,
                      onTap: _setImageType,
                    ),
                    TextField(
                      decoration: const InputDecoration(labelText: 'Name'),
                      controller: _nameController,
                    ),
                    TextField(
                      maxLines: 5,
                      decoration: const InputDecoration(labelText: 'Profile'),
                      controller: _profileController,
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: updateProfile,
              child: isLoading ? const AppLoading() : const Text('Save'),
            )
          ],
        ),
      ),
    );
  }

  Future<void> updateProfile() async {
    try {
      _setIsLoading(true);
      await FirebaseFirestore.instance
          .collection('app_users')
          .doc(widget.user.id)
          .update({
        'name': _nameController.text,
        'profile': _profileController.text,
        'image_type': selectedImageType.name,
      });

      await Future.delayed(const Duration(seconds: 1), () {
        Navigator.of(context).pop();
      });
    } catch (e) {
      print(e);
    } finally {
      _setIsLoading(false);
    }
  }
}
