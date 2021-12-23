import 'dart:ffi';

import 'package:flutter/foundation.dart';
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
      final user = await getUser(response.user!.id);
      print("User: $user}");
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
      final user = UserModel(id: response.user!.id, name: name, email: email);
      await registerUser(user);
      return user;
    } else {
      throw response.error?.message ?? "Não foi possível fazer login.";
    }
  }

  @override
  Future<UserModel> getUser(String id) async {
    final response =
        await client.from("users").select().filter("id", "eq", id).execute();
    if (response.error == null) {
      final user = UserModel.fromMap(response.data[0]);
      return user;
    } else {
      throw response.error?.message ?? "Erro ao buscar usuário";
    }
  }

  @override
  Future<UserModel> registerUser(UserModel user) async {
    await client.from("users").insert(user.toMap()).execute();
    return user;
  }

  @override
  Future<bool> create(
      {required String table, required Map<String, dynamic> data}) async {
    final response = await client.from(table).insert(data).execute();
    if (response.error != null) throw Exception(response.error!.message);
    return true;
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
}
