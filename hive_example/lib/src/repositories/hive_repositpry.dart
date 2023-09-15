import 'package:hive/hive.dart';

import '../models/local_entity.dart';
import 'hive_base_repository.dart';

class HiveRepository implements HiveBaseRepository {
  final String boxName;
  late final Box boxHive;

  HiveRepository(this.boxName) {
    boxHive = Hive.box(boxName);
  }

  @override
  Future<void> createOrUpdate(LocalEntity data) async {
    await boxHive.put(data.key, data);
  }

  @override
  List<T> getAll<T extends LocalEntity>() {
    final data = [];
    for (var value in boxHive.values) {
      data.add(value);
    }
    return List<T>.from(data);
  }

  @override
  Future<void> delete<T extends LocalEntity>(int id) async {
    await boxHive.delete(id);
  }
}
