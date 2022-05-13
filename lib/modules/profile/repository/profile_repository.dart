import 'dart:typed_data';

import 'package:meuapp/shared/models/user_model.dart';

abstract class ProfileRepository {
  Future<UserModel> getProfile({required String id});
  Future<UserModel> update({
    required String id,
    required String name,
  });
  Future<void> upload(
      {required String filePath, required Uint8List bytes, required String id});
  Future<String?> avatarUrl();
}
