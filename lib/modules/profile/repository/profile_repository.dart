import 'dart:io';

abstract class ProfileRepository {
  Future<dynamic> upload({required String path, required File file});
  String? getPublicUrl({required String path});
}
