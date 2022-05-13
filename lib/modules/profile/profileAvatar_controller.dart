import 'dart:typed_data';

import 'package:flutter/cupertino.dart';

import 'package:meuapp/modules/profile/repository/profile_repository.dart';
import 'package:meuapp/shared/utils/app_state.dart';

class ProfileAvatarController extends ChangeNotifier {
  AppState state = AppState.empty();
  ProfileRepository repository;

  ProfileAvatarController({
    required this.repository,
  });

  void update(AppState state) {
    this.state = state;
    notifyListeners();
  }

  Future updateStorage({
    required String path,
    required Uint8List bytes,
    required String id,
  }) async {
    try {
      update(AppState.loading());
      final response =
          await repository.upload(filePath: path, bytes: bytes, id: id);
      update(AppState.success<void>(response));
      this.urlAvatar();
    } catch (e) {
      update(AppState.error(e.toString()));
    }
  }

  Future<void> urlAvatar() async {
    try {
      update(AppState.loading());
      final response = await repository.avatarUrl();
      update(AppState.success<String?>(response));
    } catch (e) {
      update(AppState.error(e.toString()));
    }
  }
}
