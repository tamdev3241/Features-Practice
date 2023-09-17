import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'route/route_name.dart';

class ProfileScreen extends StatelessWidget {
  final String id;
  const ProfileScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    var data = {'id': '001', 'name': 'Thanh Tam'};
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => context.pushNamed(
                RouteName.detail,
                queryParameters: data,
              ),
              child: const Text('Go to Detail Screen'),
            ),
            Text(id),
          ],
        ),
      ),
    );
  }
}
