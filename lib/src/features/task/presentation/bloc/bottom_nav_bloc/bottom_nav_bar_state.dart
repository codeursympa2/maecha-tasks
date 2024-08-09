part of 'bottom_nav_bar_bloc.dart';

sealed class BottomNavBarState extends Equatable {
  const BottomNavBarState();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

final class BottomNavBarInitialState extends BottomNavBarState {
  @override
  List<Object> get props => [];
}

class GetIndexPage extends BottomNavBarState{
  final int index;
  
  const GetIndexPage({required this.index});

  @override
  List<Object?> get props => [index];

}

