import 'package:almost_zenly/types/image_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  AppUser({
    this.id,
    this.imageType = ImageType.lion,
    this.name = '',
    this.profile = '',
    this.coordinate,
  });

  final String? id;
  final ImageType imageType;
  final String name;
  final String profile;
  final GeoPoint? coordinate;

  factory AppUser.fromDoc(String id, Map<String, dynamic> json) => AppUser(
        id: id,
        imageType: ImageType.fromString(json['image_type']),
        name: json['name'],
        profile: json['profile'],
        coordinate: json['coordinate'],
      );
}
