import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:maecha_tasks/global/bloc/connectivity_checker_bloc.dart';
import 'package:maecha_tasks/global/services/shared_preferences_service.dart';
import 'package:maecha_tasks/src/constants/colors/light_mode/light_mode_colors.dart';
import 'package:maecha_tasks/src/features/task/presentation/bloc/task_bloc/task_bloc.dart';

Widget checkConnectivityListenerWidget({required Widget child,required SharedPreferencesService sharedPref}){
  return BlocListener<ConnectivityCheckerBloc, ConnectivityCheckerState>(
    listener: (context, state) {
      if(state is NoConnectionInternetState){
        // Show snackbar when there is no connection
        scaffoldMessenger(context, "Pas de connexion internet",Icons.signal_wifi_connected_no_internet_4, dangerLight);
      }
      if(state is ConnectionInternetState){
        //Syncronisation si l'utilisateur est connecté
        if(sharedPref.getUser() != null){
          BlocProvider.of<TaskBloc>(context).add(const SyncDataToCloudFirestore());
        }
        if(!state.firstTime){
          scaffoldMessenger(context, "Reconnecté à internet",Icons.wifi, successColorLight);
        }
      }


      if(state is SyncDataCompleted){
      }

      if(state is SyncData){
        scaffoldMessenger(context, "Echec de la syncronisation",Icons.sync_disabled_sharp, successColorLight);
      }
    },
    child: child,
  );
}

scaffoldMessenger(BuildContext context,String message,IconData iconData,Color backColor){
  ScaffoldMessenger.of(context).showSnackBar(
     SnackBar(
     padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 4),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(iconData,color: backgroundLight,),
          const Gap(3),
          Text(message)
        ],
      ),
      backgroundColor: backColor,
      duration: const Duration(seconds: 3),
    ),
  );
}