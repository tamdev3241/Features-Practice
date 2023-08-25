import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/classroom.dart';

class ClassItem extends StatelessWidget {
  final Classroom classroom;
  final Function()? onDelete;
  final Function()? onTap;
  const ClassItem({
    super.key,
    required this.classroom,
    this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final String subTitle = classroom.updatedDt != null
        ? DateFormat('yyyy/mm/DD').format(DateTime.parse(classroom.updatedDt!))
        : '';

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text(
          classroom.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        subtitle: Text(subTitle),
        tileColor: Colors.blueGrey[100],
        trailing: IconButton(
          onPressed: onDelete,
          icon: const Icon(
            Icons.delete,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
