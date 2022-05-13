import 'dart:typed_data';

import 'package:meuapp/shared/models/order_model.dart';

abstract class ProductRepository {
  Future<List<OrderModel>> allByUser({required String id_user});
  Future<bool> create({
    required String id_user,
    required String name,
    required String price,
    required String created_at,
    String? description,
    String? path,
    Uint8List? bytesImage,
  });
  Future<bool> update({
    required String id,
    required String name,
    required String price,
    required String updated_at,
    required String thumbnailOld,
    String? description,
    String? path,
    Uint8List? bytesImage,
  });
}
