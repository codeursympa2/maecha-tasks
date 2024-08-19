import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maecha_tasks/global/bloc/connectivity_checker_bloc.dart';
import 'package:maecha_tasks/global/services/shared_preferences_service.dart';
import 'package:maecha_tasks/src/constants/colors/light_mode/light_mode_colors.dart';
import 'package:maecha_tasks/src/features/task/presentation/bloc/bottom_nav_bloc/bottom_nav_bar_bloc.dart';
import 'package:maecha_tasks/src/features/task/presentation/bloc/task_bloc/task_bloc.dart';
import 'package:maecha_tasks/src/features/task/presentation/widgets/bottom_navigation_bar.dart';
import 'package:maecha_tasks/src/features/task/presentation/widgets/sync_status_message.dart';
import 'package:maecha_tasks/src/utils/check_connectivity_listener_widget.dart';

class IndexPage extends StatelessWidget {

  final SharedPreferencesService sharedPref;
  const IndexPage({super.key, required this.sharedPref});

  @override
  Widget build(BuildContext context) {
    int selectedIndex = 0;
    bool isConnected = false;

    return checkConnectivityListenerWidget(
      child: BlocConsumer<BottomNavBarBloc, BottomNavBarState>(
        listener: (context, state) {
          if (state is GetIndexPage) {
            selectedIndex = state.index;
          }
        },
        builder: (context, state) {
          return BlocListener<ConnectivityCheckerBloc,
              ConnectivityCheckerState>(
            listener: (context, state) async {
              if (state is ConnectionInternetState) {
                isConnected = true;
                //Syncronisation si l'utilisateur est connecté
                if(sharedPref.getUser() != null){
                  await Future.delayed(const Duration(seconds: 4),
                          () => BlocProvider.of<TaskBloc>(context).add(const SyncDataToCloudFirestore())
                  );
                }
              } else {
                isConnected = false;
              }
            },
            child: Scaffold(
              body: Stack(
                children: [
                  Center(
                    child: getPage(selectedIndex),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: BlocConsumer<TaskBloc, TaskState>(
                      listener: (context, state) {
                        if(state is DoublonState){
                          scaffoldMessenger(context, state.message, Icons.info, infoColorLight);
                        }

                        if( state is SyncDataFailure){
                          scaffoldMessenger(context, "Echec de la syncronisation", Icons.info, dangerLight);
                        }
                      },
                      builder: (context, state) {
                        return SyncStatusMessage(isSyncing: state is SyncData &&
                            isConnected);
                      },
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: bottomNavigationBar(
                context,
                selectedIndex,
                    (index) {
                  BlocProvider.of<BottomNavBarBloc>(context).add(
                    ChangePageEvent(index: index),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
