import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:task_management_app/task_core.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    initialLocation: RouterPath.listScreen,
    navigatorKey: _rootNavigatorKey,
    routes: [
      GoRoute(
        path: RouterPath.listScreen,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: ListsScreen()),
      ),
      GoRoute(
        path: RouterPath.searchScreen,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: SearchScreen()),
      ),
      GoRoute(
        path: RouterPath.tasksScreen,
        pageBuilder: (context, state) {
          final list =
              state.extra as TaskList; 
          return NoTransitionPage(child: TasksScreen(list: list));
        },
      ),
    ],
    // Error handler
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(child: Text('Route not found: ${state.uri.toString()}')),
    ),
  );
}
