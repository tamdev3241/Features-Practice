import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'route/route_name.dart';

class DetailScreen extends StatelessWidget {
  final Map<String, String> info;
  const DetailScreen({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => context.push(RouteName.profile),
              child: const Text('Here, Detail Screen'),
            ),
            ...info.entries.map((e) => Text(e.value)).toList(),
          ],
        ),
      ),
    );
  }
}
