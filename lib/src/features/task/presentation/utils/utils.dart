import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:maecha_tasks/src/features/task/domain/entities/task/task_model.dart';

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


