import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'bottom_nav_bar_event.dart';
part 'bottom_nav_bar_state.dart';

class BottomNavBarBloc extends Bloc<BottomNavBarEvent, BottomNavBarState> {
  BottomNavBarBloc() : super(BottomNavBarInitialState()) {
    on<GoToPageEvent>((event, emit) {
        final String path=event.pathName;

        switch (path) {
          case "home":
            emit(const GetIndexPage(index: 0));
          case "agenda":
            emit(const GetIndexPage(index: 1));
          case "task":
            emit(const GetIndexPage(index: 2));
          case "task-list":
            emit(const GetIndexPage(index: 3));
          case "account":
            emit(const GetIndexPage(index: 4));
          default:
            emit(const GetIndexPage(index: 0));
        }
    });

    on<ChangePageEvent>((event, emit) {
      final int index=event.index;

      switch (index) {
        case 0:
          emit(const GetIndexPage(index: 0));
        case 1:
          emit(const GetIndexPage(index: 1));
        case 2:
          emit(const GetIndexPage(index: 2));
        case 3:
          emit(const GetIndexPage(index: 3));
        case 4:
          emit(const GetIndexPage(index: 4));
        default:
          emit(const GetIndexPage(index: 0));
      }
    });


  }
}
