import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_example/src/models/classroom.dart';

import 'package:sqflite_example/src/screens/home_screen.dart';
import 'package:mockito/mockito.dart';

import 'homne_screen_test.mocks.dart';

@GenerateMocks([ClassroomDb, Database])
void main() {
  late MockDatabase mokcDb;

  const String tableName = "classroom";

  setUpAll(() async {
    mokcDb = MockDatabase();
  });

  tearDown(() {
    mokcDb.close();
  });

  testWidgets("Should not show any item when classroom is empty",
      (WidgetTester tester) async {
    // MockClassroomDb mockClassroomDb = MockClassroomDb();

    when(mokcDb.query(any))
        .thenAnswer((_) => Future.delayed(Duration(seconds: 1), () => []));
    // when(mockClassroomDb.fetchAll()).thenAnswer((_) async => []);

    await tester.runAsync(() async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
    });

    final findEmptyListText = find.text("No classroom here...");
    expect(findEmptyListText, findsNothing);
  });
}
