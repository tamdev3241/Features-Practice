import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_example/src/constant/string_constant.dart';
import 'package:hive_example/src/repositories/hive_repositpry.dart';
import 'package:intl/intl.dart';

import '../models/todo.dart';

class TodoForm extends StatefulWidget {
  final Todo? todo;
  final Function(Todo)? onSubmit;
  const TodoForm({
    super.key,
    this.todo,
    this.onSubmit,
  });

  @override
  State<TodoForm> createState() => _TodoFormState();
}

class _TodoFormState extends State<TodoForm> {
  late final TextEditingController subjectController = TextEditingController();
  late final TextEditingController contentController = TextEditingController();
  late final TextEditingController dateController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  late final Box todoBox;
  bool isEditting = false;

  @override
  void initState() {
    super.initState();
    isEditting = widget.todo != null;
    todoBox = Hive.box(StringConfig.todoBox);
    if (isEditting) {
      subjectController.text = widget.todo!.subject;
      contentController.text = widget.todo!.content;
      dateController.text = widget.todo!.deadline;
    }
  }

  void onSubmited(Todo todo) async {
    Future.delayed(const Duration(milliseconds: 100), () async {
      if (isEditting) {
        await todoBox.putAt(todo.id - 1, todo);
      }
      await HiveRepository(StringConfig.todoBox).createOrUpdate(todo);
    }).whenComplete(() {
      if (mounted) {
        Navigator.pop(context);
        widget.onSubmit!(todo);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                isEditting ? "Edit this todo" : "Add new todo",
                style: const TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextFormField(
              controller: subjectController,
              decoration: const InputDecoration(
                hintText: "Enter object",
              ),
              validator: (value) => value == null || value.isEmpty
                  ? "Subject will be filled"
                  : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: contentController,
              decoration: const InputDecoration(
                hintText: "Enter content",
              ),
              validator: (value) => value == null || value.isEmpty
                  ? "Content will be filled"
                  : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: dateController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.calendar_month),
                hintText: "Choose deadline",
              ),
              readOnly: true,
              onTap: () async {
                var selectedTime = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(100000),
                );
                if (selectedTime != null) {
                  var formatTime =
                      DateFormat("hh:mm dd/MM/yyyy").format(selectedTime);
                  dateController.text = formatTime;
                }
              },
              validator: (value) =>
                  value == null || value.isEmpty ? "Date will be filled" : null,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(40),
              ),
              onPressed: () {
                if (formKey.currentState?.validate() != null) {
                  int id = isEditting ? widget.todo!.id : todoBox.length + 1;
                  Todo todo = Todo(
                    id: id,
                    subject: subjectController.text.trim(),
                    deadline: dateController.text,
                    content: contentController.text.trim(),
                  );

                  onSubmited(todo);
                }
              },
              child: Text(
                isEditting ? "Edit" : "Add",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
