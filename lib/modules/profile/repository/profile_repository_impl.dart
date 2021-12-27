import 'dart:io';

import 'package:meuapp/modules/profile/repository/profile_repository.dart';
import 'package:meuapp/shared/services/app_database.dart';
import 'package:supabase/supabase.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  AppDatabase database;

  ProfileRepositoryImpl({
    required this.database,
  });

  @override
  Future<dynamic> upload({required String path, required File file}) async {
    final response = await database.uploadStorageProfile(
        bucket: "avatars", path: path, file: file);
    return response;
  }

  @override
  String? getPublicUrl({required String path}) {
    () async {
      final response =
          await database.getPublicUrl(bucket: "avatars", path: path);
      return response!;
    };
  }
}
