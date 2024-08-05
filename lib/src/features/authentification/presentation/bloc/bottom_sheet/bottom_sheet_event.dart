part of 'bottom_sheet_bloc.dart';

sealed class BottomSheetEvent extends Equatable {
  const BottomSheetEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

final class BottomSheetInitialEvent extends BottomSheetEvent{
  const BottomSheetInitialEvent();
}

class ShowPageEvent extends BottomSheetEvent{
  final BuildContext context;
  final String path;

  const ShowPageEvent({required this.context,required this.path});

  @override
  // TODO: implement props
  List<Object?> get props => [context,path];
}

class PushPageEvent extends BottomSheetEvent{
  final BuildContext context;
  final String path;
  const PushPageEvent({required this.context,required this.path});

  @override
  // TODO: implement props
  List<Object?> get props => [context,path];
}


