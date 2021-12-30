import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:meuapp/shared/models/order_model.dart';
import 'package:meuapp/shared/models/user_model.dart';
import 'package:meuapp/shared/services/app_database.dart';
import 'package:supabase/supabase.dart';

class SupabaseDatabase implements AppDatabase {
  late final SupabaseClient client;

  SupabaseDatabase() {
    init();
  }

  @override
  void init() {
    client = SupabaseClient(
      const String.fromEnvironment("SUPABASEURL"),
      const String.fromEnvironment("SUPABASEKEY"),
    );
    if (!kReleaseMode) {
      print("Database initialized");
      print("URL: ${client.supabaseUrl} -- KEY: ${client.supabaseKey}");
    }
  }

  @override
  Future<UserModel> login(
      {required String email, required String password}) async {
    final response = await client.auth.signIn(email: email, password: password);
    if (response.error == null) {
      final user = await getProfile(response.user!.id);
      return user;
    } else {
      throw Exception(
          response.error?.message ?? "Não foi possível criar conta.");
    }
  }

  @override
  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
  }) async {
    final response = await client.auth.signUp(email, password);
    if (response.error == null) {
      final user = UserModel(
          id: response.user!.id,
          name: name,
          email: email,
          avatar_url: "avatar_default.jpg");
      await registerUser(user);
      return user;
    } else {
      throw response.error?.message ?? "Não foi possível fazer login.";
    }
  }

  @override
  Future<UserModel> getProfile(String id) async {
    final response = await client
        .from("profiles")
        .select()
        .filter("id", "eq", id)
        .single()
        .execute();
    if (response.error == null) {
      final user = UserModel.fromMap(response.data);
      return user;
    } else {
      throw response.error?.message ?? "Erro ao buscar usuário";
    }
  }

  @override
  Future<UserModel> registerUser(UserModel user) async {
    await client.from("profiles").insert(user.toMap()).execute();
    return user;
  }

  @override
  Future<List<Map<String, dynamic>>> all(String table) async {
    final response =
        await client.from(table).select().order("created_at").execute();
    if (response.error != null) throw Exception(response.error!.message);
    return (response.data as List<dynamic>)
        .map((e) => e as Map<String, dynamic>)
        .toList();
  }

  @override
  Future<List<Map<String, dynamic>>> allByUser(
      {required String table, required String id_user}) async {
    final response = await client
        .from(table)
        .select()
        .filter("id_user", "eq", id_user)
        .order("created_at")
        .execute();
    if (response.error != null) throw Exception(response.error!.message);
    return (response.data as List<dynamic>)
        .map((e) => e as Map<String, dynamic>)
        .toList();
  }

  @override
  Future<bool> create(
      {required String table, required Map<String, dynamic> data}) async {
    final response = await client.from(table).insert(data).execute();
    if (response.error != null) throw Exception(response.error!.message);
    return true;
  }

  @override
  Future<bool> delete({required String table, required String id}) async {
    final response = await client.from(table).delete().eq("id", id).execute();
    if (response.error != null) throw Exception(response.error!.message);
    return true;
  }

  @override
  Future<OrderModel> show({required String table, required String id}) async {
    final response = await client.from(table).select().eq("id", id).execute();
    if (response.error == null) {
      return OrderModel.fromMap(response.data);
    } else {
      throw Exception(response.error!.message);
    }
  }

  @override
  Future<bool> update(
      {required String table,
      required String id,
      required Map<String, dynamic> data}) async {
    final response =
        await client.from(table).update(data).eq("id", id).execute();
    if (response.error != null) throw Exception(response.error!.message);
    return true;
  }

  @override
  Future<void> uploadStorage(
      {required String bucket,
      required String path,
      required Uint8List bytes,
      required String table,
      required String column}) async {
    final user = await client.auth.user();

    final response =
        await client.storage.from(bucket).uploadBinary(path, bytes);
    if (response.error == null) {
      final rmLastImage = await client
          .from(table)
          .select(column)
          .eq('id', user!.id)
          .single()
          .execute();
      if (rmLastImage.data[column] != null)
        this.deleteStorage(bucket: bucket, path: rmLastImage.data[column]);

      final responseUpThumb = await client.from(table).upsert({
        'id': user.id,
        '${column}': path,
      }).execute();

      if (responseUpThumb.error != null)
        throw Exception(responseUpThumb.error!.message);
    } else {
      throw Exception(response.error!.message);
    }
  }

  @override
  Future<void> deleteStorage({
    required String bucket,
    required String path,
  }) async {
    final response = await client.storage.from(bucket).remove(['${path}']);
    if (response.error != null)
      throw Exception("Não foi possível excluir o arquivo.");
  }

  @override
  Future<String?> getPublicUrl(
      {required String table,
      required String column,
      required String bucket}) async {
    final idUser = await client.auth.user()!.id;
    final sql =
        await client.from(table).select().eq("id", idUser).single().execute();
    final thumb_url = sql.data[column]!;
    final response = await client.storage.from(bucket).getPublicUrl(thumb_url);
    if (response.error != null) throw Exception(response.error!.message);
    return response.data;
  }

  @override
  Future<UserModel> updateProfile(
      {required String table,
      required String id,
      required Map<String, dynamic> data}) async {
    final response =
        await client.from(table).update(data).eq("id", id).execute();
    if (response.error != null) throw Exception(response.error!.message);
    return getProfile(id);
  }
}
