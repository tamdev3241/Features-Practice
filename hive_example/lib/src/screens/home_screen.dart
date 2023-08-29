import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_example/src/models/todo.dart';

import '../constant/string_constant.dart';
import '../widgets/todo_form.dart';
import '../widgets/todo_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final Box todoBox;
  List<Todo> todolist = [];

  @override
  void initState() {
    super.initState();

    todoBox = Hive.box(StringConfig.todoBox);
    getTodos();
  }

  void getTodos() async {
    todolist.clear();
    for (var key in todoBox.keys) {
      var todo = await todoBox.get(key);
      todolist.add(todo);
    }
  }

  void onSelect({Todo? todo}) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
        ),
      ),
      builder: (context) {
        return TodoForm(
          todo: todo,
          onSubmit: (todo) {
            setState(() {
              todolist.add(todo);
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("ToDo App"),
      ),
      body: todolist.isNotEmpty
          ? RefreshIndicator(
              onRefresh: () async {
                setState(() {});
              },
              child: ListView(
                children: todolist
                    .map((todo) => TodoItem(
                          todo: todo,
                          onSelected: () {
                            onSelect(todo: todo);
                          },
                          onDelete: () async {
                            await todoBox.delete(todo.id);
                            setState(() {
                              todolist.remove(todo);
                            });
                          },
                        ))
                    .toList(),
              ),
            )
          : const Center(
              child: Text("Todo list is empty !!"),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: onSelect,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 0.0,
        child: const Icon(Icons.edit_rounded),
      ),
    );
  }
}
