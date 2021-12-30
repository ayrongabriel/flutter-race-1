import 'dart:convert';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String? avatar_url;
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatar_url,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? avatar_url,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatar_url: avatar_url ?? this.avatar_url,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar_url': avatar_url,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      avatar_url: map['avatar_url'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, avatar_url: $avatar_url)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.avatar_url == avatar_url;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ email.hashCode ^ avatar_url.hashCode;
  }
}
