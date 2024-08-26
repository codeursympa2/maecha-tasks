import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:maecha_tasks/global/bloc/connectivity_checker_bloc.dart';
import 'package:maecha_tasks/global/services/shared_preferences_service.dart';
import 'package:maecha_tasks/src/constants/colors/light_mode/light_mode_colors.dart';
import 'package:maecha_tasks/src/features/task/domain/entities/task/task_model.dart';
import 'package:maecha_tasks/src/features/task/presentation/bloc/bottom_nav_bloc/bottom_nav_bar_bloc.dart';
import 'package:maecha_tasks/src/features/task/presentation/bloc/task_bloc/task_bloc.dart';
import 'package:maecha_tasks/src/features/task/presentation/pages/home_page.dart';
import 'package:maecha_tasks/src/features/task/presentation/pages/list_tasks_page.dart';
import 'package:maecha_tasks/src/features/task/presentation/pages/task_page.dart';
import 'package:maecha_tasks/src/features/task/presentation/widgets/bottom_navigation_bar.dart';
import 'package:maecha_tasks/src/features/task/presentation/widgets/sync_status_message.dart';
import 'package:maecha_tasks/src/utils/check_connectivity_listener_widget.dart';

class IndexPage extends StatelessWidget {

  final SharedPreferencesService sharedPref;
  final int defaultIndex;
  final TaskModel? taskModel;
  const IndexPage({super.key, required this.sharedPref,required this.defaultIndex,this.taskModel});

  Future<bool> _onWillPop(BuildContext context) async {
    if (taskModel != null && defaultIndex == 2) {
      return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Abandonner les modifications ?'),
          content: Text(
              'Voulez-vous vraiment abandonner les modifications en cours ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Non'),
            ),
            TextButton(
              onPressed: () => context.go("/detail-task",extra: taskModel),
              child: Text('Oui'),
            ),
          ],
        ),
      ) ??
          false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    int selectedIndex = defaultIndex;
    bool isConnected = false;

    return WillPopScope(
      onWillPop: () async =>  true,
      child: checkConnectivityListenerWidget(
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
                      child: _getPage(selectedIndex),
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
      ),
    );
  }

  Widget _getPage(
      int index,
      ) {

    bool control= taskModel != null;

    // Return the appropriate widget for each tab
    switch (index) {
      case 0:
        return const HomePage();
      case 1:
        return const Text('Agenda Page');
      case 2:
        return  control ? TaskPage(task: taskModel,) : const TaskPage();
      case 3:
        return const ListTasksPage();
      case 4:
        return const Text('Mon compte Page');
      default:
        return const Text('Home Page');
    }
  }
}
