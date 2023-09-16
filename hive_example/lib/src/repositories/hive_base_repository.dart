import '../models/local_entity.dart';

abstract class HiveBaseRepository {
  Future<void> createOrUpdate(LocalEntity data);
  List<T> getAll<T extends LocalEntity>();
  Future<void> delete<T extends LocalEntity>(int id);
}
