import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:maecha_tasks/global/injectable/injectable.dart';
import 'package:maecha_tasks/global/services/shared_preferences_service.dart';
import 'package:maecha_tasks/src/constants/strings/paths.dart';
import 'package:maecha_tasks/src/features/authentification/presentation/pages/main_page.dart';
import 'package:maecha_tasks/src/features/authentification/presentation/pages/splash_screen_page.dart';
import 'package:maecha_tasks/src/features/task/domain/entities/task/task_model.dart';
import 'package:maecha_tasks/src/features/task/presentation/pages/agenda_page.dart';
import 'package:maecha_tasks/src/features/task/presentation/pages/detail_task_page.dart';
import 'package:maecha_tasks/src/features/task/presentation/pages/home_page.dart';
import 'package:maecha_tasks/src/features/task/presentation/pages/list_tasks_page.dart';
import 'package:maecha_tasks/src/features/task/presentation/pages/profile_page.dart';
import 'package:maecha_tasks/src/features/task/presentation/pages/task_page.dart';
import 'package:maecha_tasks/src/features/task/presentation/widgets/bottom_navigation_bar.dart';

class AppRouter {


  Page getPage({
    required Widget child,
    required GoRouterState state,
  }) {
    return MaterialPage(
      key: state.pageKey,
      child: child,
    );
  }

  GoRouter router(BuildContext context) {
    final rootNavigatorKey = GlobalKey<NavigatorState>();
    final homeTabNavigatorKey = GlobalKey<NavigatorState>();
    final agendaTabNavigatorKey = GlobalKey<NavigatorState>();
    final taskTabNavigatorKey = GlobalKey<NavigatorState>();
    final listTaskTabNavigatorKey = GlobalKey<NavigatorState>();
    final profileTabNavigatorKey = GlobalKey<NavigatorState>();


    return GoRouter(
      initialLocation: defaultPath,
      navigatorKey: rootNavigatorKey,
      debugLogDiagnostics: true,
      routes: [
        StatefulShellRoute.indexedStack(
          parentNavigatorKey: rootNavigatorKey,
          branches: [
            // Home
            StatefulShellBranch(
              navigatorKey: homeTabNavigatorKey,
              routes: [
                GoRoute(
                  path: homePath,
                  pageBuilder: (context, GoRouterState state) {
                    return getPage(
                      child: const HomePage(),
                      state: state,
                    );
                  },
                ),
              ],
            ),
            // Agenda
            StatefulShellBranch(
              navigatorKey: agendaTabNavigatorKey,
              routes: [
                GoRoute(
                  path: agendaPath,
                  pageBuilder: (context, GoRouterState state) {
                    return getPage(
                      child: const AgendaPage(),
                      state: state,
                    );
                  },
                ),
              ],
            ),
            // Task
            StatefulShellBranch(
              navigatorKey: taskTabNavigatorKey,
              routes: [
                // Route for adding a new task
                GoRoute(
                  path: taskAddPath,
                  pageBuilder: (context, GoRouterState state) {
                    return getPage(
                      child: const TaskPage(),
                      state: state,
                    );
                  },
                ),
              ],
            ),
            // List Tasks
            StatefulShellBranch(
              navigatorKey: listTaskTabNavigatorKey,
              routes: [
                GoRoute(
                  path: listTaskPath,
                  pageBuilder: (context, GoRouterState state) {
                    return getPage(
                      child: const ListTasksPage(),
                      state: state,
                    );
                  },
                  routes: [
                    GoRoute(
                      path: detailsTaskPath,
                      pageBuilder: (context, state)
                      {
                        final task = state.extra as TaskModel;
                        return CustomTransitionPage<void>(
                          key: state.pageKey,
                          child:DetailTaskPage(task: task),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) =>
                              ScaleTransition(scale: animation, child: child),
                        );
                      },
                      routes: [
                        GoRoute(
                          path: taskEditPath,
                          builder: (context, GoRouterState state) {
                            TaskModel task = state.extra as TaskModel;
                            return TaskPage(task: task,);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            // Profile
            StatefulShellBranch(
              navigatorKey: profileTabNavigatorKey,
              routes: [
                GoRoute(
                  path: profilePath,
                  pageBuilder: (context, GoRouterState state) {
                    return getPage(
                      child: const ProfilePage(),
                      state: state,
                    );
                  },
                ),
              ],
            ),
          ],
          pageBuilder: (
              BuildContext context,
              GoRouterState state,
              StatefulNavigationShell navigationShell,
              ) {
            return getPage(
              child: BottomNavigationPage(
                sharedPref: getIt<SharedPreferencesService>(),
                child: navigationShell,
              ),
              state: state,
            );
          },
        ),
        // Autres routes
        GoRoute(
          parentNavigatorKey: rootNavigatorKey,
          path: defaultPath,
          pageBuilder: (context, state) =>
          const NoTransitionPage(child: SplashScreenPage()),
        ),
        GoRoute(
          parentNavigatorKey: rootNavigatorKey,
          path: mainPath,
          builder: (context, state) => const MainPage(),
        ),
      ],
    );

  }
}
