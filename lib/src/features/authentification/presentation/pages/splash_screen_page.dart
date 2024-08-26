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

  @override
  void initState() {
    super.initState();
    _checkUserAuthenticated();
  }

  void _checkUserAuthenticated(){
    BlocProvider.of<AuthBloc>(context).add(const CheckConnectUserEvent());
  }


  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if(state is AuthAuthenticatedState){
          context.go('/index',extra: {'index':0,});
        }

        if(state is AuthUnauthenticatedState){
          context.go("/main");        }
      },
      child: const Center(child: CircularProgressIndicator()),
    );
  }




}
