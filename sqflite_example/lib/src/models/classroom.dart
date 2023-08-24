import 'package:sqflite/sqflite.dart';

import '../services/db_manager.dart';

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

  Future<int> insert({required String name}) async {
    final db = await DbManager().database;
    return await db.rawInsert(
      '''INSERT INTO $tableName (name, createdDt) VALUES (?, ?)''',
      [name, DateTime.now().microsecondsSinceEpoch],
    );
  }

  Future<List<Classroom>> fetchAll() async {
    final db = await DbManager().database;
    final classrooms =
        await db.rawQuery('''SELECT * FROM $tableName ORDER BY createdDt ''');
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

  Future<List<Classroom>> fetchByLimit(int limit) async {
    final db = await DbManager().database;

    final classrooms = await db.query(
      tableName,
      limit: limit,
    );

    return classrooms.map((e) => Classroom.fromSqlDatabase(e)).toList();
  }

  Future<int> updated({required int id, String? name}) async {
    final db = await DbManager().database;

    // use query
    // return await db.rawUpdate(
    //   'UPDATE $tableName SET name = ? WHERE id = ?',
    //   [name, id],
    // );

    // use function
    return await db.update(
      tableName,
      {
        if (name != null) 'name': name,
        'createdDt': DateTime.now().microsecondsSinceEpoch,
      },
      where: 'id=?',
      conflictAlgorithm: ConflictAlgorithm.rollback,
      whereArgs: [id],
    );
  }

  Future<int> delete(int id) async {
    final db = await DbManager().database;
    // use query
    // await db.rawDelete(
    //   '''DELETE FROM $tableName WHERE id = ?''',
    //   [id],
    // );

    // Use fucntion
    return await db.delete(
      tableName,
      where: "id=?",
      whereArgs: [id],
    );
  }
}
