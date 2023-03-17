import 'package:almost_zenly/types/image_type.dart';

class AppUser {
  AppUser({
    this.id,
    this.imageType = ImageType.unknown,
    this.name = '',
    this.profile = '',
  });

  final String? id;
  final ImageType imageType;
  final String name;
  final String profile;
  // 位置情報

  factory AppUser.fromDoc(String id, Map<String, dynamic> json) => AppUser(
        id: id,
        imageType: ImageType.fromString(json['image_type']),
        name: json['name'],
        profile: json['profile'],
      );
}
