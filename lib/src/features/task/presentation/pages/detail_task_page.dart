import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:maecha_tasks/src/constants/colors/light_mode/light_mode_colors.dart';
import 'package:maecha_tasks/src/constants/numbers.dart';
import 'package:maecha_tasks/src/constants/strings/fonts_strings.dart';
import 'package:maecha_tasks/src/constants/strings/paths.dart';
import 'package:maecha_tasks/src/features/task/domain/entities/task/task_model.dart';
import 'package:maecha_tasks/src/features/task/presentation/pages/partials/bottom_sheet_options.dart';
import 'package:maecha_tasks/src/features/task/presentation/utils/utils.dart';
import 'package:intl/date_symbol_data_local.dart';
class DetailTaskPage extends StatelessWidget  {
  final TaskModel task;
  const DetailTaskPage({super.key,required this.task});

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('fr_FR', null).then((_) {});
    return Scaffold(
      appBar: AppBar(
        title:Text("Détails du tâche",style: Theme.of(context).textTheme.bodyLarge,),
        centerTitle: true,
        backgroundColor: backgroundLight,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryTextLight),  // Icône personnalisée
          onPressed: () {
             context.go(listTaskPath);
          },
        ),
        actions: [
          IconButton(onPressed: (){
            bottomSheetOptions(context: context, taskModel: task, onEditAction: (){
              context.go(
                "$listTaskPath/$detailsTaskPath/$taskEditPath",
                extra: task,
              );});
          }, icon: const Icon(Icons.more_vert))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(paddingPagesApp),
          child: Column(
            children: [
              _cardDetailTaskField(context: context, label: "Titre", content: task.title!),
              _cardDetailTaskField(context: context, label: "Description", content: task.desc!),
              _cardDetailTaskField(context: context, label: "Date de rappel", content: formatDateTimeFr(task.dateTime!)),
              _cardDetailTaskField(context: context, label: "Priorité", content: translatePriorityValue(task.priority!.name)),
              _cardDetailTaskField(context: context, label: "Etat", content: task.done! ? 'Completée' : 'En cours'),
              _cardDetailTaskField(context: context, label: "Notifications", content: task.notify! ? 'Activées' : 'Désactivées' ),
              _cardDetailTaskField(context: context, label: "Crée le", content: formatDateTimeFr(task.createdAt!)),
            ],
          ),
        ),
      ),
    );
  }
  Widget _cardDetailTaskField({required BuildContext context, required String label, required String content}){
    return SizedBox(
      width: double.infinity ,
      child: Card(
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 11),
        color: backgroundLight,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: primaryLight,
                  borderRadius: BorderRadius.circular(8)
                ),
                child: Text(label,style: const TextStyle(
                    fontFamily: quicksand,
                    fontSize: 14,
                    color: backgroundLight
                ),),
              ),
              const Gap(6),
              Text(content,
                style: Theme.of(context).textTheme.labelSmall,
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
