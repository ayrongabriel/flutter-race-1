import 'package:flutter/cupertino.dart';

import 'package:meuapp/modules/login/repositories/login_repository.dart';
import 'package:meuapp/shared/models/user_model.dart';
import 'package:meuapp/shared/utils/app_state.dart';
import 'package:validators/sanitizers.dart';

class RegisterController extends ChangeNotifier {
  final LoginRepository repository;
  AppState state = AppState.empty();
  final formKey = GlobalKey<FormState>();
  String _name = "";
  String _email = "";
  String _password = "";

  RegisterController({required this.repository});

  void onChange({String? name, String? email, String? password}) {
    _name = name ?? _name;
    _email = email ?? _email;
    _password = password ?? _password;
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

  Future<void> register() async {
    if (validate()) {
      try {
        update(AppState.loading());
        final response = await repository.register(
            name: trim(_name), email: trim(_email), password: _password);
        update(AppState.success<UserModel>(response));
      } catch (e) {
        update(AppState.error(
          "Não foi possível cadastrar o usuário",
        ));
      }
    }
  }
}
