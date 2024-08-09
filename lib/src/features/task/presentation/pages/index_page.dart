import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maecha_tasks/src/features/task/presentation/bloc/bottom_nav_bloc/bottom_nav_bar_bloc.dart';
import 'package:maecha_tasks/src/features/task/presentation/widgets/bottom_navigation_bar.dart';

class IndexPage extends StatelessWidget {
  const IndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    int selectedIndex = 0;
    return BlocConsumer<BottomNavBarBloc, BottomNavBarState>(
      listener: (context, state) {
        if (state is GetIndexPage) {
          selectedIndex = state.index;
        }
      },
      builder: (context, state) {
        return Scaffold(
          bottomNavigationBar: bottomNavigationBar(
              context, selectedIndex,
              (index){
                BlocProvider.of<BottomNavBarBloc>(context).add(
                    ChangePageEvent(index: index));
              }),
          body: Center(
            child: getPage(selectedIndex),
          ),
        );
      },
    );
  }
}
