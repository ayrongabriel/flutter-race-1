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
}
