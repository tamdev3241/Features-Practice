import 'package:flutter/material.dart';

import '../models/classroom.dart';
import '../widgets/class_item.dart';
import '../widgets/class_form.dart';

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
    if (mounted) {
      _fetchClassrooms();
    }
  }

  void _fetchClassrooms() async {
    setState(() {
      futureClassroom = classDb.fetchAll();
    });
  }

  void _showAddClassroomDialog() {
    showDialog(
      context: context,
      builder: (_) {
        return ClassForm(
          onSubmit: (className) async {
            await classDb.insert(name: className);
            _fetchClassrooms();
            if (!mounted) return;
            Navigator.pop(context);
          },
        );
      },
    );
  }

  void _showInfoClassroomDialog(Classroom classroom) {
    showDialog(
      context: context,
      builder: (_) {
        return ClassForm(
          classroom: classroom,
          onSubmit: (className) async {
            await classDb.updated(
              id: classroom.id,
              name: className,
            );
            _fetchClassrooms();
            if (!mounted) return;
            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: const Text("Classes List"),
      // ),
      body: FutureBuilder<List<Classroom>>(
        future: futureClassroom,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
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
                        onTap: () {
                          _showInfoClassroomDialog(classrooms[index]);
                        },
                      );
                    },
                  );
          }
          return const Center(child: CircularProgressIndicator());
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
