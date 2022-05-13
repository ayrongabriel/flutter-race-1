import 'dart:typed_data';

import 'package:meuapp/shared/models/order_model.dart';
import 'package:meuapp/shared/models/user_model.dart';
import 'package:meuapp/shared/services/supabase_database.dart';

abstract class AppDatabase {
  static final AppDatabase instance = SupabaseDatabase();
  void init();

  Future<UserModel> login({required String email, required String password});
  Future<UserModel> registerUser(UserModel user);
  Future<UserModel> getProfile(String id);
  Future<UserModel> register(
      {required String email, required String password, required String name});

  // Future<bool> find(String table, String id);
  Future<List<Map<String, dynamic>>> all(String table);
  Future<List<Map<String, dynamic>>> allByUser(
      {required String table, required String id_user});
  Future<bool> create(
      {required String table, required Map<String, dynamic> data});
  Future<OrderModel> show({required String table, required String id});
  Future<bool> update(
      {required String table,
      required String id,
      required Map<String, dynamic> data});
  Future<bool> delete({required String table, required String id});

  // Storage
  Future<void> uploadStorage({
    required String bucket,
    required String path,
    required Uint8List bytes,
  });
  Future<void> updateUploadStorage({
    required String bucket,
    required String path,
    required Uint8List bytes,
    required String table,
    required String column,
    required String columnRef,
  });
  Future<void> deleteStorage({required String bucket, required String path});
  Future<String?> getPublicUrl({
    required String table,
    required String column,
    required String bucket,
  });
  Future<String?> getUrlProduct({
    required String table,
    required String thumbName,
    required String bucket,
  });

  // profile
  Future<UserModel> updateProfile(
      {required String table,
      required String id,
      required Map<String, dynamic> data});
}
