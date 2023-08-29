import 'package:flutter/material.dart';

import '../models/todo.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;
  final Function()? onDelete;
  final Function()? onSelected;
  const TodoItem({
    super.key,
    required this.todo,
    this.onDelete,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        onTap: onSelected,
        title: Text(todo.subject),
        tileColor: Colors.grey[200],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        trailing: IconButton(
          onPressed: onDelete,
          icon: const Icon(
            Icons.delete_rounded,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
