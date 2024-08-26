import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:maecha_tasks/global/injectable/injectable.dart';
import 'package:maecha_tasks/global/services/shared_preferences_service.dart';
import 'package:maecha_tasks/src/features/authentification/presentation/pages/main_page.dart';
import 'package:maecha_tasks/src/features/authentification/presentation/pages/splash_screen_page.dart';
import 'package:maecha_tasks/src/features/task/domain/entities/task/task_model.dart';
import 'package:maecha_tasks/src/features/task/presentation/pages/detail_task_page.dart';
import 'package:maecha_tasks/src/features/task/presentation/pages/index_page.dart';

class AppRouter {
  static GoRouter router(BuildContext context) {
    return GoRouter(
      //refreshListenable: GoRouterRefreshStream(context.watch<AuthBloc>().stream),
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const SplashScreenPage(),
          // redirect: (context, state) {
          //   final authState = context.read<AuthBloc>().state;
          //   if (authState is AuthAuthenticatedState) {
          //     return '/home';
          //   } else if (authState is AuthUnauthenticatedState) {
          //     return '/main';
          //   }
          //   return null; // Reste sur le splash screen si l'état n'est pas déterminé
          // },
        ),
        GoRoute(
          path: '/index',
          builder: (context, state)  {
            final extras = state.extra as Map<String, dynamic>;
            //Index via bottom nav bar
            final index = extras['index'] as int;
            //L'objet task en cas de mise à jour task
            final task = extras['task'] as TaskModel?;
            return IndexPage(sharedPref: getIt<SharedPreferencesService>(), defaultIndex: index,taskModel: task,);
          },
        ),
        GoRoute(
          path: '/detail-task',
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

        ),GoRoute(
          path: '/add-task',
          builder: (context, state) {
            return IndexPage(
              sharedPref: getIt<SharedPreferencesService>(),
              defaultIndex: 2,
            );
          },
        ),
        GoRoute(
          path: '/edit-task',
          builder: (context, state) {
            final task = state.extra as TaskModel?;
            return IndexPage(
              sharedPref: getIt<SharedPreferencesService>(),
              defaultIndex: 2,
              taskModel: task,
            );
          },
        ),
        GoRoute(
          path: '/main',
          builder: (context, state) => const MainPage(),
        ),
      ],
    );
  }
}
