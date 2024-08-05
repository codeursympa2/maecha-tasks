import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maecha_tasks/global/injectable/injectable.dart';
import 'package:maecha_tasks/global/services/shared_preferences_service.dart';
import 'package:maecha_tasks/routes/app_router.dart';
import 'package:maecha_tasks/src/constants/strings/strings.dart';
import 'package:maecha_tasks/src/constants/theme/light/theme_light.dart';
import 'package:maecha_tasks/src/features/authentification/application/usecases/login_user.dart';
import 'package:maecha_tasks/src/features/authentification/application/usecases/register_user.dart';
import 'package:maecha_tasks/src/features/authentification/application/usecases/send_verification_email.dart';
import 'package:maecha_tasks/src/features/authentification/presentation/bloc/auth/auth_bloc.dart';
import 'package:maecha_tasks/src/features/authentification/presentation/bloc/bottom_sheet/bottom_sheet_bloc.dart';
import 'package:maecha_tasks/src/features/authentification/presentation/bloc/form/auth_form_bloc.dart';
import 'package:maecha_tasks/src/features/authentification/presentation/pages/main_page.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:maecha_tasks/src/features/authentification/presentation/pages/splash_screen_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        //Authentification
        BlocProvider<AuthBloc>(create: (context)=> AuthBloc(
          loginUser: getIt<LoginUser>(),
          registerUser: getIt<RegisterUser>(),
          sendVerificationEmail: getIt<SendVerificationEmail>(),
          sharedPreferencesService: getIt<SharedPreferencesService>(),
        )),
        //Bottom sheet nav
        BlocProvider<BottomSheetBloc>(create: (context)=> BottomSheetBloc()),

        //Auth form
        BlocProvider<AuthFormBloc>(create: (context) => AuthFormBloc())
      ],
      child: Builder(
        builder: (context) {
          return MaterialApp.router(
            title: appName,
            routerConfig: AppRouter.router(context),
            debugShowCheckedModeBanner: false,
            builder: EasyLoading.init(),
            theme: ThemeData(
              textTheme: textTheme,
              elevatedButtonTheme: elevatedButtonTheme,
              outlinedButtonTheme: outlinedButtonTheme,
              inputDecorationTheme: inputDecorationTheme,
              colorScheme: colorScheme,
              useMaterial3: true,
            ),
          );
        }
      ),
    );
  }
}