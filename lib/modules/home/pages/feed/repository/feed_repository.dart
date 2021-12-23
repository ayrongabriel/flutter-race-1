import 'package:meuapp/shared/models/order_model.dart';
import 'package:meuapp/shared/models/product_model.dart';

abstract class FeedRepository {
  Future<List<ProductModel>> all();
  Future<List<OrderModel>> allByUser({required String id_user});
}
