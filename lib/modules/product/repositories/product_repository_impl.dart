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
}
