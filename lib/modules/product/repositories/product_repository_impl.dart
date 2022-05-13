import 'dart:typed_data';

import 'package:meuapp/modules/product/repositories/product_repository.dart';
import 'package:meuapp/shared/models/order_model.dart';
import 'package:meuapp/shared/services/app_database.dart';

class ProductRepositoryImpl implements ProductRepository {
  final AppDatabase database;
  ProductRepositoryImpl({
    required this.database,
  });

  @override
  Future<List<OrderModel>> allByUser({required String id_user}) async {
    final response =
        await database.allByUser(table: "orders", id_user: id_user);
    return (response).map((e) => OrderModel.fromMap(e)).toList();
  }

  @override
  Future<bool> create({
    required String id_user,
    required String name,
    required String price,
    String? description,
    required String created_at,
    String? path,
    Uint8List? bytesImage,
  }) async {
    final priceParse = double.parse(price.replaceAll("R\$", ""));

    if (path != null && bytesImage != null) {
      database.uploadStorage(
        bucket: 'products',
        path: path,
        bytes: bytesImage,
      );
    }

    final response = await database.create(table: "orders", data: {
      "id_user": id_user,
      "name": name.trim(),
      "price": priceParse,
      "description": description ?? "",
      "thumbnail_url": path ?? "default.png",
      "created_at": created_at
    });

    return response;
  }

  @override
  Future<bool> update({
    required String id,
    required String name,
    required String price,
    required String updated_at,
    required String thumbnailOld,
    String? description,
    String? path,
    Uint8List? bytesImage,
  }) async {
    final priceParse = double.parse(price.replaceAll("R\$", ""));

    if (path != null && bytesImage != null) {
      database.updateUploadStorage(
        bucket: 'products',
        path: path,
        bytes: bytesImage,
        table: "orders",
        column: "thumbnail_url",
        columnRef: id,
      );

      if (thumbnailOld != "default.png")
        database.deleteStorage(
          bucket: 'products',
          path: thumbnailOld,
        );
    }

    final response = await database.update(table: "orders", id: id, data: {
      "name": name.trim(),
      "price": priceParse,
      "description": description ?? "",
      // "updated_at": updated_at
      "created_at": updated_at
    });

    return response;
  }
}
