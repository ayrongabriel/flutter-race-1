import 'dart:io';

import 'package:meuapp/shared/models/order_model.dart';
import 'package:meuapp/shared/models/user_model.dart';
import 'package:meuapp/shared/services/supabase_database.dart';

abstract class AppDatabase {
  static final AppDatabase instance = SupabaseDatabase();
  void init();

  Future<UserModel> login({required String email, required String password});
  Future<UserModel> registerUser(UserModel user);
  Future<UserModel> getUser(String id);
  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
  });

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
  Future<dynamic> uploadStorageProfile(
      {required String bucket, required String path, required File file});
  Future<dynamic> deleteStorage({required String bucket, required String path});
  String? getPublicUrl({required String bucket, required String path});
}
