import 'package:flutter/material.dart';

import '../models/classroom.dart';

class ClassForm extends StatefulWidget {
  final Classroom? classroom;
  final ValueChanged<String> onSubmit;
  const ClassForm({
    super.key,
    required this.onSubmit,
    this.classroom,
  });

  @override
  State<ClassForm> createState() => _ClassFormState();
}

class _ClassFormState extends State<ClassForm> {
  final controller = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    controller.text = widget.classroom?.name ?? "";
  }

  @override
  Widget build(BuildContext context) {
    final isEditting = widget.classroom != null;
    return AlertDialog(
      title: Text(
        isEditting ? "Edit" : "Add",
      ),
      content: Form(
        key: formKey,
        child: TextFormField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: "Class name"),
          validator: (value) =>
              value != null && value.isEmpty ? "Name is required" : null,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              widget.onSubmit(controller.text);
            }
          },
          child: const Text("OK"),
        ),
      ],
    );
  }
}
