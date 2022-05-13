import 'dart:typed_data';

import 'package:flutter/cupertino.dart';

import 'package:meuapp/modules/product/repositories/product_repository.dart';
import 'package:meuapp/shared/utils/app_state.dart';

class ProductController extends ChangeNotifier {
  AppState state = AppState.empty();
  ProductRepository repository;
  final formKey = GlobalKey<FormState>();

  String _name = "";
  String _price = "";
  String _description = "";
  String _created_at = "";
  String _updated_at = "";

  ProductController({
    required this.repository,
  });

  void onChange(
      {String? name,
      String? price,
      String? created_at,
      String? updated_at,
      String? description}) {
    _name = name ?? _name;
    _price = price ?? _price;
    _description = description ?? _description;
    _created_at = created_at ?? _created_at;
    _updated_at = updated_at ?? _updated_at;
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

  Future<void> create(
      {String? path, Uint8List? bytesImage, required String userId}) async {
    if (validate()) {
      try {
        update(AppState.loading());
        final response = await repository.create(
          id_user: userId,
          name: _name,
          price: _price,
          description: _description,
          created_at: _created_at,
          path: path,
          bytesImage: bytesImage,
        );
        if (response) {
          update(AppState.success<bool>(response));
        } else {
          throw Exception("Não foi possivel cadastrar o produto");
        }
      } catch (e) {
        update(AppState.error(e.toString()));
      }
    }
  }

  Future<void> updateOrders({
    String? path,
    Uint8List? bytesImage,
    required String orderId,
    required String thumbnailOld,
  }) async {
    if (validate()) {
      try {
        update(AppState.loading());
        final response = await repository.update(
          id: orderId,
          name: _name,
          price: _price,
          description: _description,
          updated_at: _updated_at,
          path: path,
          bytesImage: bytesImage,
          thumbnailOld: thumbnailOld,
        );
        if (response) {
          update(AppState.success<bool>(response));
        } else {
          throw Exception("Não foi possivel atualizar o produto");
        }
      } catch (e) {
        update(AppState.error(e.toString()));
      }
    }
  }
}
