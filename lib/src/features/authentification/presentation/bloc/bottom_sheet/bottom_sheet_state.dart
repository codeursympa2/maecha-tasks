part of 'bottom_sheet_bloc.dart';

sealed class BottomSheetState extends Equatable {
  const BottomSheetState();

  @override
  List<Object> get props => [];
}

final class BottomSheetInitialState extends BottomSheetState {
  const BottomSheetInitialState();
}
