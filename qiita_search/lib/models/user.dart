class User {
  final String id;
  final String iconUrl;

  User({
    required this.id,
    required this.iconUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      iconUrl: json['profile_image_url'],
    );
  }
}
