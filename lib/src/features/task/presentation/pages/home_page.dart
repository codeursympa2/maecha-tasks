import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:heroicons/heroicons.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:maecha_tasks/global/bloc/connectivity_checker_bloc.dart';
import 'package:maecha_tasks/global/services/shared_preferences_service.dart';
import 'package:maecha_tasks/src/constants/colors/light_mode/light_mode_colors.dart';
import 'package:maecha_tasks/src/constants/numbers.dart';
import 'package:maecha_tasks/src/constants/strings/strings.dart';
import 'package:maecha_tasks/src/features/task/domain/entities/task/task_model.dart';
import 'package:maecha_tasks/src/features/task/domain/value_objects/dash_task_filter_options.dart';
import 'package:maecha_tasks/src/features/task/domain/value_objects/filter_total_list.dart';
import 'package:maecha_tasks/src/features/task/presentation/bloc/task_bloc/task_bloc.dart';
import 'package:maecha_tasks/src/features/task/presentation/pages/partials/dashboard_card.dart';
import 'package:maecha_tasks/src/features/task/presentation/pages/partials/home_dash_filtered_list.dart';
import 'package:maecha_tasks/src/features/task/presentation/pages/partials/shimmer_card.dart';
import 'package:maecha_tasks/src/features/task/presentation/utils/utils.dart';


class HomePage extends StatefulWidget {
  final SharedPreferencesService local;
  const HomePage({super.key,required this.local});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>  with WidgetsBindingObserver{

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey =
  GlobalKey<LiquidPullToRefreshState>();

  static int refreshNum = 10; // number that changes when refreshed
  Stream<int> counterStream =
  Stream<int>.periodic(const Duration(seconds: 2), (x) => refreshNum).asBroadcastStream();


  @override
  void initState() {
    super.initState();
    // Ajout de l'observateur du cycle de vie
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Vérifier l'état du cycle de vie
    if (state == AppLifecycleState.resumed) {
      // Recharger les données lorsque l'application revient en avant-plan
      _loadList();
    }
  }

  @override
  void dispose() {
    // Supprimer l'observateur pour éviter les fuites de mémoire
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body:  BlocConsumer<ConnectivityCheckerBloc, ConnectivityCheckerState>(
      listener: (context, state) {
        if(state is ConnectionInternetState){
          _loadList();
        }
      },
      builder: (context, state) {
        return LiquidPullToRefresh(
            key: _refreshIndicatorKey,
            onRefresh: _handleRefresh,
            showChildOpacityTransition: false,
            color: primaryLight,
            child: StreamBuilder<int>(
              stream: counterStream,
              builder: (context,snapshot){
                return _HomePageContent(local: widget.local,);
              },
            ),
          );
      },
      ),
      appBar: AppBar(
        title:  Text(appName,style: Theme.of(context).textTheme.headlineLarge,),
        backgroundColor: backgroundLight,
        iconTheme: const IconThemeData(
          size: 26,
        ),

        actions: [
         IconButton(onPressed: (){}, icon: const HeroIcon(HeroIcons.bell,)),
         IconButton(onPressed: (){}, icon: const Icon(Icons.more_vert))
        ],
      ),
    );
  }

  void _loadList() {
    BlocProvider.of<TaskBloc>(context).add(const LoadTasksDashboard());
  }

  Future<void> _handleRefresh() async {
    _loadList();
  }
}

class _HomePageContent extends StatefulWidget {
  final SharedPreferencesService local;

  const _HomePageContent({required this.local});

  @override
  State<_HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<_HomePageContent>  {
  

  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityCheckerBloc,ConnectivityCheckerState>(
        builder: (context,state){
          if(state is ConnectionInternetState){

            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: BlocBuilder<TaskBloc, TaskState>(
                builder: (context, state) {
                  if(state is HomeDashLoadingState){
                    return _shimmerContent();
                  }
                  else if(state is HomeDashLoadedState){
                    List<TaskModel> tasks=state.list;
                    final todayList=getDashTasksWithFilter(filter: DashTaskFilterOptions.today,tasks: tasks);
                    final recentList=getDashTasksWithFilter(filter: DashTaskFilterOptions.recent,tasks: tasks);
                    final upcomingList=getDashTasksWithFilter(filter: DashTaskFilterOptions.upcoming,tasks: tasks);
                    final completedList=getDashTasksWithFilter(filter: DashTaskFilterOptions.completed,tasks: tasks,);
                    final highList=getDashTasksWithFilter(filter: DashTaskFilterOptions.priorityHigh,tasks: tasks,);
                    final lowList=getDashTasksWithFilter(filter: DashTaskFilterOptions.priorityLow,tasks: tasks,);
                    final mediumList=getDashTasksWithFilter(filter: DashTaskFilterOptions.priorityMedium,tasks: tasks);

                    return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: paddingPagesApp,vertical: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Text("Salut! ",style: Theme.of(context).textTheme.bodyLarge,),
                              const Gap(2),
                              Text(widget.local.getUser()!.fullName,style: Theme.of(context).textTheme.headlineSmall,)
                            ],),
                            Text("Soyez productive aujourd'hui",style: Theme.of(context).textTheme.titleLarge,),
                            const Gap(18),
                            _rowCustomized(
                                [
                                  DashboardCard(label: "Completés", total: getTotalWithFilter(tasks, FilterTotalList.done), iconData: Icons.check_circle),
                                  DashboardCard(label: "A faire", total:getTotalWithFilter(tasks, FilterTotalList.todo), iconData: Icons.check_box_outline_blank),
                                ]
                            ),
                            const Gap(18),
                            _rowCustomized(
                                [
                                  DashboardCard(label: "Favoris", total: getTotalWithFilter(tasks, FilterTotalList.favorite), iconData: Icons.star_border),
                                  DashboardCard(label: "Total", total: getTotalWithFilter(tasks, FilterTotalList.total), iconData: Icons.analytics),
                                ]
                            ),
                            const Gap(19),
                            //Listes par filtres
                            //Aujourd'hui
                            HomeDashFilteredList(list: todayList, label: "Aujourd'hui"),
                            //Recentes
                            HomeDashFilteredList(list: recentList, label: "Récentes", ),
                            //A venir
                            HomeDashFilteredList(list: upcomingList, label: "A venir", ),
                            //Completés
                            HomeDashFilteredList(list: completedList, label: "Completés",),
                            //Elevée
                            HomeDashFilteredList(list: highList, label: "Priorité elevée",),
                            //Basse
                            HomeDashFilteredList(list: lowList, label: "Priorité basse",),
                            //Moyenne
                            HomeDashFilteredList(list: mediumList, label: "Priorité moyenne", ),
                            const Gap(10),
                          ],
                        ),
                      );

                  }else{
                    return _shimmerContent();
                  }
                },
              ),
            );
          }

          if(state is NoConnectionInternetState){
            return const Center(
              child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.signal_wifi_connected_no_internet_4, color: primaryLight,size: 50,),
                  Gap(2),
                  Text('Oups ! Pas de connexion internet.')
                ],
              ) ,);
          }
          return  const Text("");
          },
    );
  }
  Widget _rowCustomized(List<Widget> widgets){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:widgets
    ); 
  }

  Widget _shimmerContent(){
    return Padding(
      padding: const EdgeInsets.all(paddingPagesApp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const  ShimmerCard(width: 300, height: 20, radius: 10),
          const Gap(2),
          const  ShimmerCard(width: 200, height: 20, radius: 10),
          const Gap(18),
          _rowCardDashShimmer(),
          const Gap(18),
          _rowCardDashShimmer(),
          const Gap(19),
          const  ShimmerCard(width: 130, height: 23, radius: 10),
          const Gap(10),
          shimmerTaskCard(itemCount: 4)
        ],
      ),
    );
  }

  Widget _rowCardDashShimmer(){
    const shimmerCard=ShimmerCard(width: widthDashCard, height: heightDashCard, radius: borderRadiusDashCard);
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        shimmerCard,
        shimmerCard
      ],);
  }
}