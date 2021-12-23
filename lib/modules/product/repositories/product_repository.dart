import 'package:meuapp/shared/models/product_model.dart';

abstract class ProductRepository {
  Future<bool> create(
      {required String id_user,
      required String name,
      required String price,
      required String created_at});
}
