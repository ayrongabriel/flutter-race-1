import 'dart:convert';

class ProductModel {
  String name;
  double last_price;
  double current_price;

  ProductModel({
    required this.name,
    required this.last_price,
    required this.current_price,
  });

  ProductModel copyWith({
    String? name,
    double? last_price,
    double? current_price,
  }) {
    return ProductModel(
      name: name ?? this.name,
      last_price: last_price ?? this.last_price,
      current_price: current_price ?? this.current_price,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'last_price': last_price,
      'current_price': current_price,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      name: map['name'] ?? '',
      last_price: map['last_price']?.toDouble() ?? 0.0,
      current_price: map['current_price']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'ProductModel(name: $name, last_price: $last_price, current_price: $current_price)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductModel &&
        other.name == name &&
        other.last_price == last_price &&
        other.current_price == current_price;
  }

  @override
  int get hashCode =>
      name.hashCode ^ last_price.hashCode ^ current_price.hashCode;
}
