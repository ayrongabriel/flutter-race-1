import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:meuapp/modules/profile/repository/profile_repository.dart';
import 'package:meuapp/shared/utils/app_state.dart';

class ProfileController extends ChangeNotifier {
  AppState state = AppState.empty();
  ProfileRepository repository;

  ProfileController({
    required this.repository,
  });

  void update(AppState state) {
    this.state = state;
    notifyListeners();
  }

  Future updateStorage({required String path, required File file}) async {
    try {
      update(AppState.loading());
      final response = await repository.upload(path: path, file: file);
      update(AppState.success<String>(response));
    } catch (e) {
      update(AppState.error(e.toString()));
    }
  }

  String urlAvatar({required String? path}) {
    // if (path == null) return;
    var response;
    () async {
      try {
        update(AppState.loading());
        response = await repository.getPublicUrl(path: path!);
        print("teste response: ${response}");
        update(AppState.success<String>(response));
      } catch (e) {
        update(AppState.error(e.toString()));
      }
    };
    if (response == null) return "";

    return response;
  }
}
