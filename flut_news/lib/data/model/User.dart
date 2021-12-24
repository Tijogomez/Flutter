class User {
  final String username, password, imageUrl;
  final String? email;

  const User(
      {required this.username,
      required this.password,
      required this.imageUrl,
      this.email = null});

  Map<String, Object?> toJson() => {
        'username': username,
        'password': password,
        'email': email,
        'imageUrl': imageUrl
      };

  static User fromJson(Map<String, Object?> json) => User(
      username: json['username'] as String,
      password: json['password'] as String,
      email: json['email'] as String?,
      imageUrl: json['imageUrl'] as String);
}

final List<String> UserColumns = ['username', 'password', 'email', 'imageUrl'];
final UserTableName = "USERS";
