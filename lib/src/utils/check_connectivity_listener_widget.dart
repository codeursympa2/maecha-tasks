import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:maecha_tasks/global/bloc/connectivity_checker_bloc.dart';
import 'package:maecha_tasks/src/constants/colors/light_mode/light_mode_colors.dart';

Widget checkConnectivityListenerWidget({required Widget child}){
  return BlocListener<ConnectivityCheckerBloc, ConnectivityCheckerState>(
    listener: (context, state) {
      if(state is NoConnectionInternetState){
        // Show snackbar when there is no connection
        _scaffoldMessenger(context, "Pas de connexion internet",Icons.signal_wifi_connected_no_internet_4, dangerLight);
      }
      if(state is ConnectionInternetState){
        if(!state.firstTime){
          _scaffoldMessenger(context, "Reconnecté à internet",Icons.wifi, successColorLight);
        }
      }
    },
    child: child,
  );
}

_scaffoldMessenger(BuildContext context,String message,IconData iconData,Color backColor){
  ScaffoldMessenger.of(context).showSnackBar(
     SnackBar(
     padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 4),
      content: Row(
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