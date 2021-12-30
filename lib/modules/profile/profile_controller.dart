import 'package:flutter/cupertino.dart';

import 'package:meuapp/modules/profile/repository/profile_repository.dart';
import 'package:meuapp/shared/models/user_model.dart';
import 'package:meuapp/shared/utils/app_state.dart';

class ProfileController extends ChangeNotifier {
  AppState state = AppState.empty();
  ProfileRepository repository;
  UserModel userModel;

  final formKey = GlobalKey<FormState>();
  String _name = "";

  ProfileController({
    required this.repository,
    required this.userModel,
  });

  void onChange({String? name}) {
    _name = name ?? _name;
    print(name);
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

  Future<void> updateProfile() async {
    if (validate()) {
      try {
        update(AppState.loading());
        final response = await repository.update(id: userModel.id, name: _name);
        this.getProfile();
        update(AppState.success<UserModel>(response));
      } catch (e) {
        update(AppState.error(e.toString()));
      }
    }
  }

  Future<void> getProfile() async {
    try {
      update(AppState.loading());
      final response = await repository.getProfile(id: userModel.id);
      update(AppState.success<UserModel>(response));
    } catch (e) {
      update(AppState.error(e.toString()));
    }
  }
}
