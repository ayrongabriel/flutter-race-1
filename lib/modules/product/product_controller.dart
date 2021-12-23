import 'package:flutter/cupertino.dart';

import 'package:meuapp/modules/product/repositories/product_repository.dart';
import 'package:meuapp/shared/models/user_model.dart';
import 'package:meuapp/shared/utils/app_state.dart';

class ProductController extends ChangeNotifier {
  AppState state = AppState.empty();
  UserModel user;
  ProductRepository repository;
  final formKey = GlobalKey<FormState>();

  String _name = "";
  String _price = "";
  String _created_at = "";
  ProductController({
    required this.user,
    required this.repository,
  });

  void onChange({String? name, String? price, String? created_at}) {
    _name = name ?? _name;
    _price = price ?? _price;
    _created_at = created_at ?? _created_at;

    print(
        "Dados da compra\n\nName: ${_name} | Price: ${_price} | Data: ${_created_at}");
  }

  bool validate() {
    final form = formKey.currentState!;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void update(AppState state) {
    this.state = state;
    notifyListeners();
  }

  Future<void> create() async {
    if (validate()) {
      try {
        update(AppState.loading());
        final response = await repository.create(
            id_user: user.id,
            name: _name,
            price: _price,
            created_at: _created_at);
        if (response) {
          print(response);
          update(AppState.success<bool>(response));
        } else {
          throw Exception("Não foi possivel cadastrar o produto");
        }
      } catch (e) {
        update(AppState.error(e.toString()));
      }
    }
  }
}
