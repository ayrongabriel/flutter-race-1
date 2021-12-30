import 'dart:typed_data';

import 'package:meuapp/modules/product/repositories/product_repository.dart';
import 'package:meuapp/shared/services/app_database.dart';

class ProductRepositoryImpl implements ProductRepository {
  final AppDatabase database;
  ProductRepositoryImpl({
    required this.database,
  });

  @override
  Future<bool> create(
      {required String id_user,
      required String name,
      required String price,
      String? description,
      required String created_at,
      String? path,
      Uint8List? bytesImage}) async {
    final priceParse = double.parse(price.replaceAll("R\$", ""));
    final response = await database.create(table: "orders", data: {
      "id_user": id_user,
      "name": name.trim(),
      "price": priceParse,
      "description": description ?? "",
      "created_at": created_at
    });
    if (path != null && bytesImage != null) {
      upload(filePath: path, bytes: bytesImage);
    }
    return response;
  }

  @override
  Future<bool> update({
    required String id,
    required String name,
    required String price,
    String? description,
  }) async {
    final priceParse = double.parse(price.replaceAll("R\$", ""));
    final response = await database.update(table: "orders", id: id, data: {
      "name": name.trim(),
      "price": priceParse,
      "description": description ?? "",
      "updated_at": DateTime.now().toIso8601String()
    });
    return response;
  }

  @override
  Future<void> upload(
      {required String filePath, required Uint8List bytes}) async {
    final response = await database.uploadStorage(
        bucket: 'products',
        path: filePath,
        bytes: bytes,
        table: 'orders',
        column: 'thumbnail_url');
    return response;
  }

  @override
  Future<String?> avatarUrl() async {
    final response = await database.getPublicUrl(
        table: "orders", column: "tumbnail_url", bucket: "products");
    return response!;
  }
}
