import 'package:flutter/cupertino.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:maecha_tasks/src/constants/numbers.dart';
import 'package:maecha_tasks/src/features/task/domain/entities/task/task_model.dart';
import 'package:maecha_tasks/src/features/task/domain/value_objects/dash_task_filter_options.dart';
import 'package:maecha_tasks/src/features/task/domain/value_objects/filter_total_list.dart';
import 'package:maecha_tasks/src/features/task/domain/value_objects/task_priority.dart';
import 'package:maecha_tasks/src/features/task/presentation/pages/partials/shimmer_card.dart';

String? Function(dynamic) requiredFieldForm(){
  return FormBuilderValidators.required(errorText: 'Ce champ est obligatoire');
}

DateTime combineDateAndTime(String dateString, String hourString) {
  // Convertir les chaînes en DateTime
  DateTime date = DateTime.parse(dateString);
  DateTime time = DateTime.parse(hourString);

  // Extraire la date et l'heure
  int year = date.year;
  int month = date.month;
  int day = date.day;
  int hourOfDay = time.hour;
  int minute = time.minute;

  // Créer un nouveau DateTime en combinant la date et l'heure
  DateTime combinedDateTime = DateTime(year, month, day, hourOfDay, minute);

  return combinedDateTime;
}

Map<String, String> splitDateTime(DateTime dateTime) {
  // Extraire la date et l'heure sous forme de chaînes
  String dateString = "${dateTime.year.toString().padLeft(4, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
  String hourString = "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";

  // Retourner la Map contenant la date et l'heure
  return {
    "date": dateString,
    "time": hourString,
  };
}

List<TaskModel>? filterTasks(List<TaskModel> tasks, int filterOption) {
  if (filterOption == -1) {
    return tasks;
  }

  final now = DateTime.now();
  final filteredTasks = tasks.where((task) {
    if (task.dateTime == null) return false;

    switch (filterOption) {
      case 0: // Hier
        final yesterday = now.subtract(const Duration(days: 1));
        return isSameDay(task.dateTime!, yesterday);
      case 1: // Demain
        final tomorrow = now.add(const Duration(days: 1));
        return isSameDay(task.dateTime!, tomorrow);
      case 2: // Semaine prochaine
        final nextWeekStart = now.add(Duration(days: (7 - now.weekday + 1)));
        final nextWeekEnd = nextWeekStart.add(const Duration(days: 6));
        return task.dateTime!.isAfter(nextWeekStart) &&
            task.dateTime!.isBefore(nextWeekEnd);
      case 3: // Mois passé
        final lastMonth = DateTime(now.year, now.month - 1);
        return isSameMonth(task.dateTime!, lastMonth);
      case 4: // Mois prochain
        final nextMonth = DateTime(now.year, now.month + 1);
        return isSameMonth(task.dateTime!, nextMonth);
      default: // Aujourd'hui
        return isSameDay(task.dateTime!, now);
    }
  }).toList();

  return filteredTasks.isEmpty ? null : filteredTasks;
}

bool isSameDay(DateTime date1, DateTime date2) {
  return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
}

bool isSameMonth(DateTime date1, DateTime date2) {
  return date1.year == date2.year && date1.month == date2.month;
}


int getTotalWithFilter(List<TaskModel> list,FilterTotalList choice){
  List<TaskModel> done= list.where((task) => task.done == true).toList();
  List<TaskModel> todo= list.where((task) => task.done == false).toList();
  List<TaskModel> favorites= list.where((task) => task.favorite == true).toList();

  if(choice == FilterTotalList.done){
    return done.length;
  }else if(choice == FilterTotalList.todo){
    return todo.length;
  }else if(choice == FilterTotalList.favorite){
    return favorites.length;
  }
  else{
    return list.length;
  }
}

List<TaskModel> getDashTasksWithFilter(
    {
    required DashTaskFilterOptions filter,
    required List<TaskModel> tasks,
    }){
  // Obtenir la date et l'heure actuelle
  final now = DateTime.now();

  // Trier et filtrer les tâches selon le filtre sélectionné
  List<TaskModel> filteredTasks;

  switch(filter){
    //Aujourd'hui
    case DashTaskFilterOptions.today:
      filteredTasks = tasks.where((task) {
        return task.dateTime != null &&
            task.dateTime!.year == now.year &&
            task.dateTime!.month == now.month &&
            task.dateTime!.day == now.day;
      }).toList();
      break;
    //48 heures
    case DashTaskFilterOptions.recent:
      final recentCutoff = now.subtract(const Duration(hours: 48));
      filteredTasks = tasks.where((task) {
        return task.createdAt != null && task.createdAt!.isAfter(recentCutoff);
      }).toList();
      break;

    //Deux prochaines semaine A venir
    case DashTaskFilterOptions.upcoming:
      final twoWeeksFromNow = now.add(const Duration(days: 14));
      filteredTasks = tasks.where((task) {
        return task.dateTime != null &&
            task.dateTime!.isAfter(now) &&
            task.dateTime!.isBefore(twoWeeksFromNow);
      }).toList();
      break;
    //Completés
    case DashTaskFilterOptions.completed:
      filteredTasks = tasks.where((task) => task.done == true).toList();
      break;
    //Priorité elevée
    case DashTaskFilterOptions.priorityHigh:
      filteredTasks = tasks.where((task) => task.priority == TaskPriority.high).toList();
      break;
    //Priorité moyenne
    case DashTaskFilterOptions.priorityMedium:
      filteredTasks = tasks.where((task) => task.priority == TaskPriority.medium).toList();
      break;
    //Priorité basse
    case DashTaskFilterOptions.priorityLow:
      filteredTasks = tasks.where((task) => task.priority == TaskPriority.low).toList();
      break;
    }

  return filteredTasks;
}

Widget shimmerTaskCard({required int itemCount}){
  return ListView.builder(
      shrinkWrap: true,  // Important pour éviter le problème de contraintes
      physics: const NeverScrollableScrollPhysics(),  // Désactive le scroll si tu es déjà dans une scrollable view
      itemCount: itemCount,
      itemBuilder: (context,index){
        return const ShimmerCard(marginVertical: marginVerticalCard,width: double.infinity,height: 100,radius: radiusTaskCard);
      });
}


