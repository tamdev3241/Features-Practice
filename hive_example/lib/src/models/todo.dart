import 'package:hive/hive.dart';

import '../constant/string_constant.dart';
import 'local_entity.dart';

part 'todo.g.dart';

@HiveType(typeId: 1)
class Todo extends LocalEntity {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String subject;

  @HiveField(2)
  final String content;

  @HiveField(3)
  final String deadline;

  @HiveField(4, defaultValue: false)
  final bool? isComplete;

  Todo({
    required this.id,
    required this.subject,
    required this.deadline,
    required this.content,
    this.isComplete = false,
  });

  @override
  String get tableName => StringConfig.todoBox;

  @override
  String get key => id.toString();
}
