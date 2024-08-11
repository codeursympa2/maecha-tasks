part of 'connectivity_checker_bloc.dart';

sealed class ConnectivityCheckerState extends Equatable {
  const ConnectivityCheckerState();

  @override
  List<Object?> get props => [];
}

final class ConnectivityCheckerInitialState extends ConnectivityCheckerState {
  const ConnectivityCheckerInitialState();
}

class ConnectionInternetState extends ConnectivityCheckerState {
  final bool firstTime;
  const ConnectionInternetState({required this.firstTime});

  @override
  // TODO: implement props
  List<Object?> get props => [firstTime];
}

final class NoConnectionInternetState extends ConnectivityCheckerState {
  const NoConnectionInternetState();
}
