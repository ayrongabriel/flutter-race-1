import 'dart:typed_data';

import 'package:meuapp/modules/profile/repository/profile_repository.dart';
import 'package:meuapp/shared/models/user_model.dart';
import 'package:meuapp/shared/services/app_database.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  AppDatabase database;

  ProfileRepositoryImpl({
    required this.database,
  });

  @override
  Future<UserModel> getProfile({required String id}) async {
    final response = await database.getProfile(id);
    return response;
  }

  @override
  Future<void> upload(
      {required String filePath,
      required Uint8List bytes,
      required String id}) async {
    final response = await database.updateUploadStorage(
      bucket: 'avatars',
      path: filePath,
      bytes: bytes,
      table: 'profiles',
      column: 'avatar_url',
      columnRef: id,
    );
    return response;
  }

  @override
  Future<String?> avatarUrl() async {
    final response = await database.getPublicUrl(
        table: "profiles", column: "avatar_url", bucket: "avatars");
    return response!;
  }

  Future<UserModel> update({required String id, required String name}) async {
    final response =
        await database.updateProfile(table: "profiles", id: id, data: {
      "name": name.trim(),
      "updated_at": DateTime.now().toIso8601String(),
    });
    return response;
  }
}
