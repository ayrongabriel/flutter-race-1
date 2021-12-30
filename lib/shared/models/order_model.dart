import 'dart:convert';

class OrderModel {
  String id;
  String id_user;
  String name;
  double price;
  String? description;
  String? thumbnail_url;
  String created_at;

  OrderModel({
    required this.id,
    required this.id_user,
    required this.name,
    required this.price,
    this.description,
    this.thumbnail_url,
    required this.created_at,
  });

  OrderModel copyWith({
    String? id,
    String? id_user,
    String? name,
    double? price,
    String? description,
    String? thumbnail_url,
    String? created_at,
  }) {
    return OrderModel(
      id: id ?? this.id,
      id_user: id_user ?? this.id_user,
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
      thumbnail_url: thumbnail_url ?? this.thumbnail_url,
      created_at: created_at ?? this.created_at,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_user': id_user,
      'name': name,
      'price': price,
      'description': description,
      'thumbnail_url': thumbnail_url,
      'created_at': created_at,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] ?? '',
      id_user: map['id_user'] ?? '',
      name: map['name'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      description: map['description'] ?? "",
      thumbnail_url: map['thumbnail_url'] ?? "",
      created_at: map['created_at'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderModel.fromJson(String source) =>
      OrderModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'OrderModel(id: $id, id_user: $id_user, name: $name, price: $price, description: $description, thumbnail_url: $thumbnail_url, created_at: $created_at)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OrderModel &&
        other.id == id &&
        other.id_user == id_user &&
        other.name == name &&
        other.price == price &&
        other.description == description &&
        other.thumbnail_url == thumbnail_url &&
        other.created_at == created_at;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        id_user.hashCode ^
        name.hashCode ^
        price.hashCode ^
        description.hashCode ^
        thumbnail_url.hashCode ^
        created_at.hashCode;
  }
}
