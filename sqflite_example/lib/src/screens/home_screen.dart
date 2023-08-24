import 'package:flutter/material.dart';
import 'package:sqflite_example/src/models/classroom.dart';
import 'package:sqflite_example/src/widgets/create_class_form.dart';

import '../widgets/class_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<Classroom>>? futureClassroom;
  final classDb = ClassroomDb();

  @override
  void initState() {
    super.initState();
    _fetchClassrooms();
  }

  void _fetchClassrooms() async {
    setState(() {
      futureClassroom = classDb.fetchAll();
    });
  }

  _showAddClassroomDialog() {
    showDialog(
        context: context,
        builder: (_) {
          return CreateClassForm(
            onSubmit: (className) async {
              await classDb.add(name: className);
              _fetchClassrooms();
              if (!mounted) return;
              Navigator.pop(context);
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Classes List"),
      ),
      body: FutureBuilder<List<Classroom>>(
        future: futureClassroom,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            final classrooms = snapshot.data!;

            return classrooms.isEmpty
                ? const Center(
                    child: Text(
                      "No classroom here...",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        color: Colors.black,
                      ),
                    ),
                  )
                : ListView.separated(
                    itemCount: classrooms.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      return ClassItem(
                        classroom: classrooms[index],
                        onDelete: () async {
                          await classDb.delete(classrooms[index].id);
                          _fetchClassrooms();
                        },
                        onTap: () {},
                      );
                    },
                  );
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddClassroomDialog,
        child: const Icon(
          Icons.add_rounded,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}
