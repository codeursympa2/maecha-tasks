part of 'bottom_nav_bar_bloc.dart';

sealed class BottomNavBarEvent extends Equatable {
  const BottomNavBarEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}


class GoToPageEvent extends BottomNavBarEvent{
  final String pathName;

  const GoToPageEvent({required this.pathName});

  @override
  // TODO: implement props
  List<Object?> get props => [pathName];
}
class ChangePageEvent extends BottomNavBarEvent{
  final int index;

  const ChangePageEvent({required this.index});

  @override
  // TODO: implement props
  List<Object?> get props => [index];
}