import 'package:almost_zenly/components/app_loading.dart';
import 'package:almost_zenly/models/app_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoading = false;

  setIsLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              height: 40,
              width: double.infinity,
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return Container();
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
            ),
            StreamBuilder(
              stream: _fetchAppUser(),
              builder: (
                BuildContext context,
                AsyncSnapshot snapshot,
              ) {
                final appUser = snapshot.data;

                if (appUser == null) {
                  return const Center(child: AppLoading());
                }

                return Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // アイコン画像
                        CircleAvatar(
                          radius: 100,
                          backgroundImage: AssetImage(appUser.imageType.path),
                          backgroundColor: Colors.transparent,
                        ),
                        const SizedBox(height: 20),
                        // ユーザー名
                        Text(
                          appUser.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // プロフィール詳細
                        Text(
                          appUser.profile,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            TextButton(
              onPressed: () => _signOut(context),
              child: isLoading
                  ? const AppLoading(color: Colors.blue)
                  : const Text('サインアウト'),
            ),
          ],
        ),
      ),
    );
  }

  Stream<AppUser?> _fetchAppUser() {
    try {
      // ログイン中のユーザーのuidを取得
      final userId = FirebaseAuth.instance.currentUser?.uid;

      // ドキュメントのストリームを取得
      return FirebaseFirestore.instance
          .collection('app_users')
          .doc(userId)
          .snapshots()
          // ストリームの中身をAppUserクラスに変換
          .map((doc) => AppUser.fromDoc(
                doc.id,
                doc.data()!,
              ));
    } catch (e) {
      print(e);
    }
    return const Stream.empty();
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      setIsLoading(true);
      await Future.delayed(
        const Duration(seconds: 1),
        () => FirebaseAuth.instance.signOut(),
      );
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      print(e);
    } finally {
      setIsLoading(false);
    }
  }
}
