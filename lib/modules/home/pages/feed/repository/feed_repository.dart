import 'package:meuapp/shared/models/order_model.dart';
import 'package:meuapp/shared/models/product_model.dart';

abstract class FeedRepository {
  Future<List<ProductModel>> all();
  Future<List<OrderModel>> allByUser({required String id_user});
  Future<bool> create(
      {required String id_user,
      required String name,
      required String price,
      required String created_at});
  Future<bool> delete({required String id});
  Future<bool> update(
      {required String id,
      required String name,
      required String price,
      required String created_at});
}
