import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maecha_tasks/global/bloc/connectivity_checker_bloc.dart';
import 'package:maecha_tasks/src/constants/colors/light_mode/light_mode_colors.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:maecha_tasks/src/constants/numbers.dart';
import 'package:maecha_tasks/src/features/task/presentation/bloc/task_bloc/task_bloc.dart';
import 'package:maecha_tasks/src/features/task/presentation/pages/item/task_card.dart';

class ListTasksPage extends StatelessWidget {
  const ListTasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  const Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: paddingPagesApp, vertical: 4),
          child: ListTasks(),
        ),
      ),
    );
  }


}

class ListTasks extends StatefulWidget {
  const ListTasks({super.key});

  @override
  State<ListTasks> createState() => _ListTasksState();
}

class _ListTasksState extends State<ListTasks> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //Chargement
    _loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConnectivityCheckerBloc, ConnectivityCheckerState>(
      listener: (context, state) {
        if(state is ConnectionInternetState || state is NoConnectionInternetState){
          _loadTasks();
        }
      },
      child: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoadingState) {
            return  ListView.builder(
                itemCount: 8,
                itemBuilder: (context,index){
              return _shimmer();
            });
          } else if (state is TaskLoadedState) {
            final list = state.taskList;
            return RefreshIndicator(
              onRefresh: () async {
                // Recharger les tâches en déclenchant l'événement
                _loadTasks();
              },
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return TaskCard(task: list[index]);
                },
              ),
            );
          } else if (state is TaskFailureState) {
            return Center(child: Text('Erreur : ${state.message}'));
          }  else if (state is EmptyListTasksState) {
            return const Center(child: Text('Aucune tâche disponible.'));
          } else {
            return const Center(child: Text('Traitement en cours ...'));
          }
        },
      ),
    );
  }

  void _loadTasks(){
    BlocProvider.of<TaskBloc>(context).add(const GetTasksEvent());
  }

  Widget _shimmer(){
    return Shimmer(
      // This is the ONLY required parameter
      duration: const Duration(seconds: 1),
      // This is NOT the default value. Default value: Duration(seconds: 0)
      interval: const Duration(seconds: 1),
      // This is the default value
      color: Colors.black12,
      // This is the default value
      colorOpacity: 0.2,
      // This is the default value
      enabled: true,
      // This is the default value
      direction: const ShimmerDirection.fromLTRB(),
      // This is the ONLY required parameter
      child: Container(
        decoration: const BoxDecoration(
          color: skeletonColorLight,
          borderRadius: BorderRadius.all(Radius.circular(radiusTaskCard)),
        ),
        width: double.infinity,
        height: 100,
        margin: const EdgeInsets.symmetric(vertical: marginVerticalCard),
      ),
    );
  }


}
