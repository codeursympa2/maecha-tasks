part of 'connectivity_checker_bloc.dart';

sealed class ConnectivityCheckerEvent extends Equatable {
  const ConnectivityCheckerEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class CheckConnectionInternetEvent extends ConnectivityCheckerEvent{
  final bool result;
  const CheckConnectionInternetEvent({required this.result});

  @override
  List<Object?> get props => [result];
}


