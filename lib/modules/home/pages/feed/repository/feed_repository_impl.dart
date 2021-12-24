import 'package:meuapp/modules/home/pages/feed/repository/feed_repository.dart';
import 'package:meuapp/shared/models/order_model.dart';
import 'package:meuapp/shared/models/product_model.dart';
import 'package:meuapp/shared/services/app_database.dart';

class FeedRepositoryImpl implements FeedRepository {
  final AppDatabase database;

  FeedRepositoryImpl({
    required this.database,
  });

  @override
  Future<List<ProductModel>> all() async {
    final response = await database.all("orders");
    return (response).map((e) => ProductModel.fromMap(e)).toList();
  }

  @override
  Future<List<OrderModel>> allByUser({required String id_user}) async {
    final response =
        await database.allByUser(table: "orders", id_user: id_user);
    return (response).map((e) => OrderModel.fromMap(e)).toList();
  }

  @override
  Future<bool> create(
      {required String id_user,
      required String name,
      required String price,
      required String created_at}) async {
    final priceParse = double.parse(price.replaceAll("R\$", ""));
    final response = await database.create(table: "orders", data: {
      "id_user": id_user,
      "name": name.trim(),
      "price": priceParse,
      "created_at": created_at
    });
    return response;
  }

  @override
  Future<bool> delete({required String id}) async {
    final response = await database.delete(table: "orders", id: id);
    return response;
  }

  @override
  Future<bool> update(
      {required String id,
      required String name,
      required String price,
      required String created_at}) async {
    final priceParse = double.parse(price.replaceAll("R\$", ""));
    final response = await database.update(table: "orders", id: id, data: {
      "name": name.trim(),
      "price": priceParse,
      "created_at": created_at
    });
    return response;
  }
}
