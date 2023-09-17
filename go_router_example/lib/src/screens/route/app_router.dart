import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../detail_screen.dart';
import '../home_screen.dart';
import '../profile_screen.dart';
import 'route_name.dart';

class AppRouter {
  static final GoRouter _router = GoRouter(
    debugLogDiagnostics: true,
    routes: <RouteBase>[
      GoRoute(
        path: RouteName.home,
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            name: RouteName.profile,
            path: "${RouteName.profile}/:id",
            pageBuilder: (context, state) {
              return CustomTransitionPage<void>(
                key: state.pageKey,
                child: ProfileScreen(id: state.pathParameters['id']!),
                transitionDuration: const Duration(milliseconds: 150),
                transitionsBuilder: (_, animation, __, child) => FadeTransition(
                  opacity:
                      CurveTween(curve: Curves.easeInOut).animate(animation),
                  child: child,
                ),
              );
            },
          ),
          GoRoute(
            name: RouteName.detail,
            path: RouteName.detail,
            pageBuilder: (context, state) => CustomTransitionPage<void>(
              child: DetailScreen(info: state.uri.queryParameters),
              barrierDismissible: true,
              barrierColor: Colors.black38,
              opaque: false,
              transitionDuration: const Duration(milliseconds: 500),
              reverseTransitionDuration: const Duration(milliseconds: 200),
              transitionsBuilder: (_, animation, __, child) => FadeTransition(
                opacity: animation,
                child: child,
              ),
            ),
          ),
        ],
      ),
    ],
  );

  static GoRouter get router => _router;
}
