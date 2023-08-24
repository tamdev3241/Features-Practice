import 'package:sqflite/sqflite.dart';
import 'package:sqflite_example/src/services/db_manager.dart';

class Classroom {
  final int id;
  final String name;
  final String? updatedDt;

  Classroom({
    required this.id,
    required this.name,
    this.updatedDt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory Classroom.fromSqlDatabase(Map<String, dynamic> map) {
    return Classroom(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      updatedDt: map['updatedDt'] == null
          ? null
          : DateTime.fromMicrosecondsSinceEpoch(map['updatedDt'])
              .toIso8601String(),
    );
  }
  @override
  String toString() {
    super.toString();
    return "Class $name";
  }
}

class ClassroomDb {
  final tableName = 'classroom';

  Future<void> createTable(Database db) async {
    await db.execute("""CREATE TABLE IF NOT EXISTS $tableName (
      "id" INTEGER NOT NULL,
      "name" TEXT NOT NULL,
      "createdDt" INTEGER,
      PRIMARY KEY("id" AUTOINCREMENT)
    );""");
  }

  Future<int> add({required String name}) async {
    final db = await DbManager().database;
    return await db.rawInsert(
      '''INSERT INTO $tableName (name, createdDt) VALUES (?, ?)''',
      [name, DateTime.now().microsecondsSinceEpoch],
    );
  }

  Future<List<Classroom>> fetchAll() async {
    final db = await DbManager().database;
    final classrooms =
        await db.rawQuery('''SELECT * FROM $tableName ORDER BY createdDt''');
    return classrooms.map((e) => Classroom.fromSqlDatabase(e)).toList();
  }

  Future<Classroom> fetchById(int id) async {
    final db = await DbManager().database;
    final classrooms = await db.rawQuery(
      '''SELECT * FROM $tableName WHERE "id" = ?''',
      [id],
    );
    return Classroom.fromSqlDatabase(classrooms.first);
  }

  Future<int> updated({required int id, String? name}) async {
    final db = await DbManager().database;
    return await db.update(
      tableName,
      {
        if (name != null) 'name': name,
        'updatedDt': DateTime.now().microsecondsSinceEpoch,
      },
      where: 'id=?',
      conflictAlgorithm: ConflictAlgorithm.rollback,
      whereArgs: [id],
    );
  }

  Future<void> delete(int id) async {
    final db = await DbManager().database;
    await db.rawDelete(
      '''DELETE FROM $tableName WHERE id = ?''',
      [id],
    );
  }
}
