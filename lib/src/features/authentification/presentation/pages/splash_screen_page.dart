import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:maecha_tasks/global/injectable/injectable.dart';
import 'package:maecha_tasks/global/services/shared_preferences_service.dart';

import 'package:maecha_tasks/src/features/authentification/presentation/bloc/auth/auth_bloc.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {

  late AppLifecycleListener _listener;

  @override
  void initState() {
    super.initState();
    _listener = AppLifecycleListener(
        onStateChange: _onStateChange()
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if(state is AuthAuthenticatedState){
          context.go("/home");
        }

        if(state is AuthUnauthenticatedState){
          context.go("/main");        }
      },
      child: const Center(child: CircularProgressIndicator()),
    );
  }



  _onStateChange() {
    //getIt<FirebaseAuth>().signOut();
    //getIt<SharedPreferencesService>().clearData("user");
    BlocProvider.of<AuthBloc>(context).add(const CheckConnectUserEvent());
  }
}
