abstract class ProductRepository {
  Future<bool> create(
      {required String id_user,
      required String name,
      required String price,
      required String created_at});
  Future<bool> update(
      {required String id,
      required String name,
      required String price,
      required String created_at});
}
