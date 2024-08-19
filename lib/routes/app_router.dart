import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:maecha_tasks/global/injectable/injectable.dart';
import 'package:maecha_tasks/global/services/shared_preferences_service.dart';
import 'package:maecha_tasks/src/features/authentification/presentation/pages/main_page.dart';
import 'package:maecha_tasks/src/features/authentification/presentation/pages/splash_screen_page.dart';
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
          path: '/home',
          builder: (context, state) => IndexPage(sharedPref: getIt<SharedPreferencesService>(),),
        ),
        GoRoute(
          path: '/main',
          builder: (context, state) => const MainPage(),
        ),
      ],
    );
  }
}
