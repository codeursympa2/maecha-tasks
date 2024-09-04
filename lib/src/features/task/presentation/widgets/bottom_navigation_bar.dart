import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:maecha_tasks/global/bloc/connectivity_checker_bloc.dart';
import 'package:maecha_tasks/global/services/shared_preferences_service.dart';
import 'package:maecha_tasks/src/constants/colors/light_mode/light_mode_colors.dart';
import 'package:maecha_tasks/src/features/task/presentation/bloc/task_bloc/task_bloc.dart';
import 'package:maecha_tasks/src/features/task/presentation/widgets/sync_status_message.dart';
import 'package:maecha_tasks/src/utils/check_connectivity_listener_widget.dart';

class BottomNavigationPage extends StatefulWidget {
  final StatefulNavigationShell child;
  final SharedPreferencesService sharedPref;

  const BottomNavigationPage({super.key, required this.child,required this.sharedPref});

  @override
  State<BottomNavigationPage> createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  bool isConnected = false;
  @override
  Widget build(BuildContext context) {
    return BlocListener<ConnectivityCheckerBloc, ConnectivityCheckerState>(
      listener: (context, state) async {
        if (state is ConnectionInternetState) {
          setState(() {
            isConnected = true;
          });
          //Syncronisation si l'utilisateur est connecté
          if(widget.sharedPref.getUser() != null){
            await Future.delayed(const Duration(seconds: 4),
                    () => BlocProvider.of<TaskBloc>(context).add(const SyncDataToCloudFirestore())
            );
          }
        } else {
          setState(() {
            isConnected = false;
          });
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Center(
                child: checkConnectivityListenerWidget(child: widget.child),
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
        ),
        bottomNavigationBar: bottomNavigationBar(
            context, widget.child.currentIndex, (index) {
          widget.child.goBranch(
            index,
            initialLocation: index == widget.child.currentIndex,
          );
          setState(() {});
        }),
      ),
    );
  }
}


BottomNavigationBar bottomNavigationBar(BuildContext context, int selectedIndex,
    onItemTapped) {
  return BottomNavigationBar(
      enableFeedback: false,
      type: BottomNavigationBarType.fixed,
      backgroundColor: backgroundLight,
      selectedItemColor: primaryLight,
      unselectedItemColor: primaryTextLight,
      onTap: onItemTapped,
      currentIndex: selectedIndex,
      items: [
        _buildBottomNavigationBarItem(
            icon: HeroIcons.home,
            label: 'Accueil',
            selectedIndex: selectedIndex
        ),
        _buildBottomNavigationBarItem(
            icon: HeroIcons.calendar,
            label: 'Agenda',
            selectedIndex: selectedIndex
        ),
        _buildBottomNavigationBarItem(
            icon: HeroIcons.plusCircle,
            label: 'Ajouter',
            selectedIndex: selectedIndex
        ),
        _buildBottomNavigationBarItem(
            icon: HeroIcons.clipboardDocumentList,
            label: 'Tâches',
            selectedIndex: selectedIndex
        ),
        _buildBottomNavigationBarItem(
            icon: HeroIcons.user,
            label: 'Mon compte',
            selectedIndex: selectedIndex
        ),
      ]
  );
}

BottomNavigationBarItem _buildBottomNavigationBarItem({
  required HeroIcons icon,
  required String label,
  required int selectedIndex
}) {
  return BottomNavigationBarItem(

    icon: HeroIcon(
      icon,
      size: label == "Ajouter" ? 50 : 24,
      style: selectedIndex == _bottomNavItems.indexOf(label)
          ? HeroIconStyle.solid
          : HeroIconStyle.outline,
    ),
    label: label == "Ajouter" ? "" : label,
  );
}


final List<String> _bottomNavItems = [
  'Accueil',
  'Agenda',
  'Ajouter',
  'Tâches',
  'Mon compte',
];

String tooltip(int index) {
  switch (index) {
    case 0:
      return _bottomNavItems[0];
    case 1:
      return _bottomNavItems[1];
    case 2:
      return _bottomNavItems[2];
    case 3:
      return _bottomNavItems[3];
    case 4:
      return _bottomNavItems[4];
    default:
      return _bottomNavItems[5];
  }
}

