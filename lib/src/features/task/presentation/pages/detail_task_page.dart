import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:maecha_tasks/src/constants/colors/light_mode/light_mode_colors.dart';
import 'package:maecha_tasks/src/features/task/domain/entities/task/task_model.dart';
import 'package:maecha_tasks/src/features/task/presentation/bloc/bottom_nav_bloc/bottom_nav_bar_bloc.dart';
import 'package:maecha_tasks/src/features/task/presentation/bloc/task_bloc/task_bloc.dart';
import 'package:maecha_tasks/src/features/task/presentation/pages/items/bottom_sheet_options.dart';

class DetailTaskPage extends StatelessWidget  {
  final TaskModel task;
  const DetailTaskPage({super.key,required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryTextLight),  // Icône personnalisée
          onPressed: () {
              context.go("/index",extra: {'index':3});
          },
        ),
        actions: [
          IconButton(onPressed: (){
            bottomSheetOptions(context: context, taskModel: task, onEditAction: (){
              context.go("/edit-task", extra: task);
             });
          }, icon: const Icon(Icons.more_vert))
        ],
      ),
      body: Text(task.title!),
    );
  }
}
