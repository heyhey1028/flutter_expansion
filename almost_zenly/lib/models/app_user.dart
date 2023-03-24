import 'package:cloud_firestore/cloud_firestore.dart';

const String blankImage =
    'https://firebasestorage.googleapis.com/v0/b/gs-expansion-test.appspot.com/o/unknown_person.png?alt=media';

class AppUser {
  AppUser({
    this.id,
    this.name = '',
    this.profile = '',
    this.location,
    this.imageUrl = blankImage,
  });

  final String? id;
  final String name;
  final String profile;
  final GeoPoint? location;
  final String imageUrl;

  factory AppUser.fromDoc(String id, Map<String, dynamic> json) => AppUser(
        id: id,
        name: json['name'],
        profile: json['profile'],
        location: json['location'],
        imageUrl: json['image_url'] ?? blankImage,
      );
}
