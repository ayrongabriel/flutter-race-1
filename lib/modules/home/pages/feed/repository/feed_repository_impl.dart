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
}
