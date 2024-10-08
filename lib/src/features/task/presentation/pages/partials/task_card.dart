import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:heroicons/heroicons.dart';
import 'package:maecha_tasks/src/constants/colors/light_mode/light_mode_colors.dart';
import 'package:maecha_tasks/src/constants/numbers.dart';
import 'package:maecha_tasks/src/features/task/domain/entities/task/task_model.dart';
import 'package:maecha_tasks/src/features/task/domain/value_objects/task_priority.dart';
import 'package:maecha_tasks/src/features/task/presentation/utils/utils.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onTapOptions;

  const TaskCard({super.key, required this.task,required this.onTapOptions});

  @override
  Widget build(BuildContext context) {
    Color currentPriorityColor=_getColorTaskByPriority(task.priority!.name);
    return Card(
      margin: const EdgeInsets.all(0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(radiusTaskCard))
      ),
      color: backgroundLight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: currentPriorityColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(radiusTaskCard)),
            ),
            child: Row(
              children: [
                const HeroIcon(HeroIcons.flag,size: 20,style: HeroIconStyle.outline,color: backgroundLight,),
                const Gap(2),
                Text(translatePriorityValue(task.priority!.name),
                  style: const TextStyle(color: backgroundLight),
                ),
                const Spacer(),

                //A venir
              ],
            ),
          ),
          const Gap(4),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text(
                _truncateTitle(task.title!),
                style: Theme.of(context).textTheme.labelSmall,
              ),
              const Gap(6),
              Container(width: double.infinity, color: secondaryTextLight,height: 0.5,),
              const Gap(6),
              Row(
                children: [
                  const HeroIcon(HeroIcons.clock,style: HeroIconStyle.solid, color: secondaryTextLight, size: 16),
                  const Gap(4),
                  Text(_getDateDecompose(task.dateTime!, "hour"), style: const TextStyle(color: secondaryTextLight)),
                  const Spacer(),
                  const HeroIcon(HeroIcons.calendar,style: HeroIconStyle.solid, color: secondaryTextLight, size: 16),
                  const Gap(4),
                  Text(_getDateDecompose(task.dateTime!, "date"), style: const TextStyle(color: secondaryTextLight)),
                ],
              ),
            ],),
          )
        ],
      ),
    );
  }

  Color _getColorTaskByPriority(String priority){
    if(priority == TaskPriority.low.name){
      return lowPriorityColor;
    }else if(priority == TaskPriority.medium.name){
      return mediumPriorityColor;
    }else{
      return highPriorityColor;
    }
  }



  String _getDateDecompose(DateTime date,String option){
    if(option=="date"){
      return "${date.day.toString().padLeft(2,'0')}-${date.month.toString().padLeft(2,'0')}-${date.year}";
    }else{
      return "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
    }
  }

  String _truncateTitle(String title){
    const limit=35;
    if(title.length >= limit){
      return "${title.substring(0,limit)}...";
    }

    return title;
  }
}

