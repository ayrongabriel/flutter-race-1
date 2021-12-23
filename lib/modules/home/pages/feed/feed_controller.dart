import 'package:flutter/cupertino.dart';

import 'package:meuapp/modules/home/pages/feed/repository/feed_repository.dart';
import 'package:meuapp/shared/models/order_model.dart';
import 'package:meuapp/shared/models/product_model.dart';
import 'package:meuapp/shared/models/user_model.dart';
import 'package:meuapp/shared/utils/app_state.dart';

class FeedController extends ChangeNotifier {
  AppState state = AppState.empty();
  FeedRepository repository;
  UserModel user;

  FeedController({
    required this.repository,
    required this.user,
  });

  void update(AppState state) {
    this.state = state;
    notifyListeners();
  }

  List<OrderModel> get ordersByUser => state.when(
        success: (value) => value,
        orElse: () => [],
      );

  List<OrderModel> get ordersAll => state.when(
        success: (value) => value,
        orElse: () => [],
      );

  double get sum {
    var sum = 0.0;
    for (var s in ordersByUser) sum += s.price;
    return sum;
  }

  List<ProductModel> get products {
    final products = <ProductModel>[];
    for (var prod in ordersAll) {
      final product = ProductModel(
          name: prod.name, last_price: 0, current_price: prod.price);
      final index = products.indexWhere((element) => element.name == prod.name);
      if (index != -1) {
        final currentProduct = products[index];
        products[index] = currentProduct.copyWith(last_price: prod.price);
      } else {
        products.add(product);
      }
    }
    return products;
  }

  double calcChart(List<ProductModel> products) {
    var up = 0;
    var down = 0;
    for (var prod in products) {
      if (prod.current_price < prod.last_price) {
        up += 1;
      } else {
        down += 1;
      }
    }
    final result = down / up;
    if (result > 1) {
      return 1;
    } else {
      return result;
    }
  }

  Future<void> all() async {
    try {
      update(AppState.loading());
      final response = await repository.all();
      update(AppState.success<List<ProductModel>>(response));
    } catch (e) {
      update(AppState.error(e.toString()));
    }
  }

  Future<void> allByUser() async {
    try {
      update(AppState.loading());
      final response = await repository.allByUser(id_user: user.id);
      update(AppState.success<List<OrderModel>>(response));
    } catch (e) {
      update(AppState.error(e.toString()));
    }
  }
}
