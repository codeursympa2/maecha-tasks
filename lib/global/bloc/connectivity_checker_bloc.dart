import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'connectivity_checker_event.dart';
part 'connectivity_checker_state.dart';

@lazySingleton
class ConnectivityCheckerBloc extends Bloc<ConnectivityCheckerEvent, ConnectivityCheckerState> {
  late StreamSubscription<List<ConnectivityResult>> _subscription;
  late int val;

  ConnectivityCheckerBloc() : super(const ConnectivityCheckerInitialState()) {
    val=0;
   //à l'initialisation du bloc
    _subscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> connectivityResult) {
      if (connectivityResult.contains(ConnectivityResult.mobile) || connectivityResult.contains(ConnectivityResult.wifi) || connectivityResult.contains(ConnectivityResult.ethernet) ) {
        add(const CheckConnectionInternetEvent(result: true));
      }else{
        // No available network types
        add(const CheckConnectionInternetEvent(result: false));
      }
    });
    on<CheckConnectionInternetEvent>((event, emit) {

      if (event.result) {
        //Si c'est au lancement et on a une connexion on affiche pas le message
        val == 0 ?
            emit(const ConnectionInternetState(firstTime: true)) :
            emit(const ConnectionInternetState(firstTime: false));
      } else {
        emit(const NoConnectionInternetState());
      }
      val++;
    });

  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
