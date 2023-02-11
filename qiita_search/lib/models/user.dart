class User {
  final String name;
  final String iconUrl;
  final String id;

  User({
    required this.name,
    required this.iconUrl,
    required this.id,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      iconUrl: json['profile_image_url'],
      id: json['id'],
    );
  }
}
