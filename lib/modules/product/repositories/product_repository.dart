import 'dart:typed_data';

abstract class ProductRepository {
  Future<bool> create(
      {required String id_user,
      required String name,
      required String price,
      String? description,
      required String created_at,
      String? path,
      Uint8List? bytesImage});
  Future<bool> update(
      {required String id,
      required String name,
      required String price,
      String? description});
  Future<void> upload({required String filePath, required Uint8List bytes});
  Future<String?> avatarUrl();
}
