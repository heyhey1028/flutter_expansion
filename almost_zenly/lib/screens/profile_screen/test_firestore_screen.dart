import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TestFirestoreScreen extends StatefulWidget {
  const TestFirestoreScreen({super.key});

  @override
  State<TestFirestoreScreen> createState() => _TestFirestoreScreenState();
}

class _TestFirestoreScreenState extends State<TestFirestoreScreen> {
  dynamic data;
  String docId = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Firestore'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            width: double.infinity,
            height: 200,
            color: Colors.grey[300],
            child: Text(data.toString()),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () => onCreate(),
                  child: const Text('Create'),
                ),
                ElevatedButton(
                  onPressed: () => onGet(),
                  child: const Text('Get'),
                ),
                ElevatedButton(
                  onPressed: () => onUpdate(),
                  child: const Text('Update'),
                ),
                ElevatedButton(
                  onPressed: () => onDelete(),
                  child: const Text('Delete'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> onCreate() async {
    FirebaseFirestore.instance.collection('users').add({
      'name': 'Hoge hoge',
      'age': 42,
      'married': true,
      'address': {
        'street': 'Hoge street',
        'city': 'Hoge city',
      },
      'friends': [
        {'name': 'Fuga fuga', 'age': 42},
        {'name': 'Piyo piyo', 'age': 42},
      ]
    }).then((DocumentReference documentReference) {
      print(documentReference.id);
      setState(() {
        docId = documentReference.id;
      });
    }).catchError((error) {
      print(error);
    });
  }

  Future<void> onGet() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(docId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print(documentSnapshot.data());
        setState(() {
          data = documentSnapshot.data();
        });
      }
    });
  }

  Future<void> onUpdate() async {}

  Future<void> onDelete() async {}
}
