import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'route/route_name.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.push('/${RouteName.profile}/001'),
          child: const Text('ProfileScreen'),
        ),
      ),
    );
  }
}
