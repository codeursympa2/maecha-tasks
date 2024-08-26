import 'dart:async';
import 'dart:math';

import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:maecha_tasks/global/bloc/connectivity_checker_bloc.dart';
import 'package:maecha_tasks/src/constants/colors/light_mode/light_mode_colors.dart';
import 'package:maecha_tasks/src/constants/strings/form_strings.dart';
import 'package:maecha_tasks/src/features/task/presentation/bloc/bottom_nav_bloc/bottom_nav_bar_bloc.dart';
import 'package:maecha_tasks/src/features/task/presentation/pages/items/task_card.dart';
import 'package:maecha_tasks/src/utils/easy_loading_messages.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:maecha_tasks/src/constants/numbers.dart';
import 'package:maecha_tasks/src/features/task/presentation/bloc/task_bloc/task_bloc.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import '../../domain/entities/task/task_model.dart';

class ListTasksPage extends StatelessWidget {
  const ListTasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  const Scaffold(
      body: SafeArea(
        child: ListTasks(),
      ),
    );
  }
}

class ListTasks extends StatefulWidget {
  const ListTasks({super.key});

  @override
  State<ListTasks> createState() => _ListTasksState();
}

class _ListTasksState extends State<ListTasks> with SingleTickerProviderStateMixin {
  //
  List<TaskModel> listTasks=[];
  List<TaskModel> defaultListTasks=[];


  //Pour le refresh
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey =
  GlobalKey<LiquidPullToRefreshState>();

  static int refreshNum = 10; // number that changes when refreshed
  Stream<int> counterStream =
  Stream<int>.periodic(const Duration(seconds: 2), (x) => refreshNum).asBroadcastStream();

  int tag = -1;

  List<String> filterOptions = [
    'Aujourd\'hui',
    'Hier',
    'Demain',
    'Semaine prochaine',
    'Mois passé',
    'Mois prochain',
  ];
  //Slidable
  late final controller = SlidableController(this);


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //Chargement
    _loadTasks();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      body: MultiBlocListener(
      listeners: [
        BlocListener<ConnectivityCheckerBloc, ConnectivityCheckerState>(
            listener: (context, state) {
              if(state is ConnectionInternetState || state is NoConnectionInternetState){
                _loadTasks();
              }
            },
        ),
        BlocListener<TaskBloc, TaskState>(
          listener: (context, state) {
            if(state is TaskLoadedState){
              setState(() {
                defaultListTasks=state.taskList;
                listTasks=defaultListTasks;
              });
            }
            //A chaque fois qu'on filtre
            if(state is ListTaskFilteredState){
              setState(() {
                listTasks=state.taskList;
              });
            }

            //Pour la suppression
            if(state is TaskLoadingState){
              showCustomMessage(message: waiting);
            }
            if(state is TaskDeleteSuccessState){
              showCustomSuccess(message: state.message);
            }

            if(state is TaskDeleteFailureState){
              showCustomError(message: state.message);
            }

          },
        ),
      ],
      child: BlocBuilder<TaskBloc,TaskState>(
        builder: (context,state){
          if(state is TaskLoadingShimmerState){
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: paddingPagesApp,vertical: 5),
              child: Column(
                children: [
                  const Gap(8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: _shimmerFilterOptions(),
                  ),
                  const Gap(10),
                  Expanded(
                    child: ListView.builder(
                        itemCount: 8,
                        itemBuilder: (context,index){
                          return _shimmer(marginVertical: marginVerticalCard,width: double.infinity,height: 100,radius: radiusTaskCard);
                        }),
                  ),
                ],
              ),
            );
          }else  if(state is TaskLoadedState || state is ListTaskFilteredState){
            return _contentList();
          }
          else if(state is EmptyListTasksState){
            return  Padding(
              padding: const EdgeInsets.all(paddingPagesApp),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Aucune tâche disponible.'),
                  const Gap(3),
                  SizedBox(
                    width: 90,
                    child: ElevatedButton(
                        onPressed: (){
                          BlocProvider.of<BottomNavBarBloc>(context).add(const GoToPageEvent(pathName: 'task'));
                        },
                        child: const Text("Créer"),
                    ),
                  )
                ],
                            ),
              ),);
          }else if(state is TaskFailureState){
            return  Center(child: Expanded(child: Text('Erreur : ${state.message}')));
          }
          else{
            return const Center(child: Text('Chargement en cours ...'));
          }
        },
      ),
    ),
    );
  }

  void _loadTasks(){
    BlocProvider.of<TaskBloc>(context).add(const GetTasksEvent());
  }

  Widget _shimmer({required double width, required double height, required double radius,double marginVertical=0,double marginHorz=0}){
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
        decoration: BoxDecoration(
          color: skeletonColorLight,
          borderRadius: BorderRadius.all(Radius.circular(radius)),
        ),
        width: width,
        height: height,
        margin: EdgeInsets.symmetric(vertical: marginVertical,horizontal: marginHorz),
      ),
    );
  }

  Widget _contentList(){
    return LiquidPullToRefresh(
      key: _refreshIndicatorKey,
      onRefresh: _handleRefresh,
      showChildOpacityTransition: false,
      color: primaryLight,
      child: StreamBuilder<int>(
        stream: counterStream,
        builder: (context,snapshot){
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: paddingPagesApp,vertical: 5),
            child: Column(
              children: [
                //filter
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ChipsChoice<int>.single(
                    value: tag,
                    onChanged: (val) => setState((){
                      tag=val;
                      //Pour chaque filtrage on prend la liste par défaut en local
                      BlocProvider.of<TaskBloc>(context).add(FilterTasksEvent(list: defaultListTasks, tag: val));
                    }),
                    choiceItems: C2Choice.listFrom<int, String>(
                      source: filterOptions,
                      value: (i, v) => i,
                      label: (i, v) => v,
                      tooltip: (i, v) => v,
                    )..insert(
                        0, const C2Choice<int>(value: -1, label: 'Toutes')),
                    choiceStyle: C2ChipStyle.filled(
                      color: secondaryTextLight,
                      checkmarkColor: Colors.green,
                      overlayColor: primaryLight,
                      foregroundColor: backgroundLight,
                      foregroundStyle:  Theme.of(context).textTheme.headlineMedium,
                      borderRadius:
                      const BorderRadius.all(Radius.circular(roundedFilterOptions)),
                      selectedStyle: C2ChipStyle.filled(
                        color: primaryLight,
                      ),
                    ),
                  ),
                ),
                //list
                Expanded(
                  child: listTasks.isNotEmpty ? ListView.builder(
                    itemCount: listTasks.length,
                    itemBuilder: (context, index) {
                      TaskModel currentTask=listTasks[index];
                      return Column(
                        children: [
                          BlocBuilder<ConnectivityCheckerBloc,ConnectivityCheckerState>(
                              builder: (BuildContext context, ConnectivityCheckerState state) {
                                //En cas de connexion
                                if(state is ConnectionInternetState){
                                  return Slidable(
                                      key: const ValueKey(0),
                                      startActionPane: actionTask(currentTask),
                                      endActionPane: actionTask(currentTask),
                                      closeOnScroll: true,
                                      child: GestureDetector(
                                          onTap: (){
                                            //Aller à la partie detail
                                            context.go("/detail-task",extra: currentTask);
                                          },
                                          child: _taskCard(currentTask)
                                      )
                                  );
                                }
                                //en absence de la copnnexion pas suppression ni partage
                                else if(state is NoConnectionInternetState){
                                  return _taskCard(currentTask);
                                }else{
                                  return const Gap(0);
                                }
                              },
                          ),
                          const Gap(marginVerticalCard+5),
                        ],
                      );
                    },
                  ):const Center(child: Text("Pas de tâches pour ce filtre."),),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _handleRefresh() {
    final Completer<void> completer = Completer<void>();
    Timer(const Duration(seconds: 1), () {
      completer.complete();
    });
    setState(() {
      refreshNum = Random().nextInt(100);
    });
    return completer.future.then<void>((_) {
      setState(() {
        tag=-1;
      });
      _loadTasks();
      //_refreshIndicatorKey.currentState!.show();
    });
  }

  Widget _shimmerFilterOptions(){
    final shimmerObj=_shimmer(width: 120, height: 28, radius: roundedFilterOptions,marginHorz: 8);
    return Row(children: [
      shimmerObj,
      shimmerObj,
      shimmerObj,
      shimmerObj,
    ],);
  }

  void _deleteTask(TaskModel task) {
    BlocProvider.of<TaskBloc>(context).add(DeleteTaskRemoteEvent(task: task));
  }

  ActionPane actionTask(TaskModel currentTask){
    return ActionPane(
      // A motion is a widget used to control how the pane animates.
      motion: const ScrollMotion(),
      //dismissible: DismissiblePane(onDismissed: () {}),
      children:[
        const Gap(4),
        // A SlidableAction can have an icon and/or a label.
        SlidableAction(
          onPressed: (context){
            _deleteTask(currentTask);
          },
          backgroundColor: dangerLight,
          foregroundColor: backgroundLight,
          spacing: 10,
          borderRadius: const BorderRadius.all(Radius.circular(radiusTaskCard)),
          icon: Icons.delete,
        ),
        const Gap(2),
        SlidableAction(
          onPressed: (context){

          },
          borderRadius: const BorderRadius.all(Radius.circular(radiusTaskCard)),
          backgroundColor: infoColorLight,
          foregroundColor: backgroundLight,
          icon: Icons.share,
        ),
        const Gap(4),
      ],
    );
  }

  Widget _taskCard(TaskModel task) {
    return TaskCard(
      task: task,
      onTapOptions: (){
        //En cliquant sur les 3 points
      },);
  }
}
