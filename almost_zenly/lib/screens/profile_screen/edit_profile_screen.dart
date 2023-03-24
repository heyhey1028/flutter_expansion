import 'dart:io';

import 'package:almost_zenly/components/app_loading.dart';
import 'package:almost_zenly/models/app_user.dart';
import 'package:almost_zenly/types/image_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
  String imageUrl = '';
  bool isLoading = false;
  bool isImageLoading = false;

  @override
  void initState() {
    _nameController.text = widget.user.name;
    _profileController.text = widget.user.profile;
    imageUrl = widget.user.imageUrl;
    super.initState();
  }

  void _setIsLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  void _setIsImageLoading(bool value) {
    setState(() {
      isImageLoading = value;
    });
  }

  void setImageUrl(String value) {
    setState(() {
      imageUrl = value;
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
                    // アイコン画像
                    GestureDetector(
                      onTap: () => pickImage(widget.user.id!),
                      child: CircleAvatar(
                        radius: 100,
                        backgroundImage: NetworkImage(imageUrl),
                        foregroundColor: Colors.transparent,
                        child: isImageLoading
                            ? const AppLoading(
                                color: Colors.blue,
                              )
                            : null,
                      ),
                    ),
                    // ユーザー名のテキストフィールド
                    TextField(
                      decoration: const InputDecoration(labelText: 'Name'),
                      controller: _nameController,
                    ),
                    // プロフィール詳細のテキストフィールド
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
        'image_url': imageUrl,
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

  // アップロード処理
  Future<void> pickImage(String userId) async {
    // 画像のソースを選択する
    final source = await showModalBottomSheet<ImageSource?>(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera),
            title: const Text('カメラ'),
            onTap: () => Navigator.of(context).pop(ImageSource.camera),
          ),
          ListTile(
            leading: const Icon(Icons.photo),
            title: const Text('ギャラリー'),
            onTap: () => Navigator.of(context).pop(ImageSource.gallery),
          ),
        ],
      ),
    );
    if (source == null) {
      return;
    }

    // imagePickerで画像を選択する
    final pickerFile = await ImagePicker().pickImage(source: source);
    if (pickerFile == null) {
      return;
    }
    File file = File(pickerFile.path);

    // 画像をアップロードする
    try {
      _setIsImageLoading(true);
      final TaskSnapshot task = await FirebaseStorage.instance
          .ref("users/${pickerFile.name}")
          .putFile(file);
      final url = await task.ref.getDownloadURL();
      setImageUrl(url);
    } catch (e) {
      print(e);
    } finally {
      _setIsImageLoading(false);
    }
  }
}
