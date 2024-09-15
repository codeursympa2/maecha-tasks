import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:maecha_tasks/global/injectable/injectable.dart';
import 'package:maecha_tasks/global/services/shared_preferences_service.dart';
import 'package:maecha_tasks/src/constants/strings/paths.dart';
import 'package:maecha_tasks/src/constants/strings/strings.dart';

import 'package:maecha_tasks/src/features/authentification/presentation/bloc/auth/auth_bloc.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> with WidgetsBindingObserver{

  @override
  void initState() {
    super.initState();
    _checkUserAuthenticated();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Vérifier l'état du cycle de vie
    if (state == AppLifecycleState.resumed) {
      _checkUserAuthenticated();
    }
  }

  void _checkUserAuthenticated(){
    BlocProvider.of<AuthBloc>(context).add(const CheckConnectUserEvent());
  }


  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if(state is AuthAuthenticatedState){
          context.go(homePath);
        }

        if(state is AuthUnauthenticatedState){
          context.go(mainPath);
        }
      },

      child:  SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 3), // Occupe de l'espace en haut
            Center(child: Text(appName,style: Theme.of(context).textTheme.headlineLarge)),
            const Spacer(flex: 3,), // Pousse le texte suivant vers le bas
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Center(
               child:Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Text("Projet de fin de certification en Dev Mobile de ",style: Theme.of(context).textTheme.titleMedium,),
                    Text("FORCE-N",style: Theme.of(context).textTheme.bodySmall,)
                  ],),
                  const Gap(7),
                  Text("Réalisé par",style: Theme.of(context).textTheme.titleMedium),
                  const Gap(7),
                  Text("Abdallah ANRICHIDINE",style: Theme.of(context).textTheme.bodySmall,),
                ],
              )),
            ),
          ],
        ),

      ),
    );
  }




}
