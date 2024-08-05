import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:tn_bottom_sheet_navigator/tn_bottom_sheet_navigator.dart';

part 'bottom_sheet_event.dart';
part 'bottom_sheet_state.dart';

class BottomSheetBloc extends Bloc<BottomSheetEvent, BottomSheetState> {
  BottomSheetBloc() : super(const BottomSheetInitialState()) {
    on<BottomSheetInitialEvent>((event, emit) {
      emit(const BottomSheetInitialState());
    });

    on<ShowPageEvent>((event, emit) {
      event.context.showTnBottomSheetNav(
        event.path,
      );
    });
    on<PushPageEvent>((event, emit) {
      event.context.tnPush(event.path);
    });

  }

}
