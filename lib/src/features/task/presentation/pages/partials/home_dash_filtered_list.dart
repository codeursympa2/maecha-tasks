import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:heroicons/heroicons.dart';
import 'package:maecha_tasks/src/constants/numbers.dart';
import 'package:maecha_tasks/src/features/task/domain/entities/task/task_model.dart';
import 'package:maecha_tasks/src/features/task/presentation/pages/partials/task_card.dart';

class HomeDashFilteredList extends StatefulWidget {
  final List<TaskModel> list;
  final String label;

  const HomeDashFilteredList({
    super.key,
    required this.list,
    required this.label,
  });

  @override
  State<HomeDashFilteredList> createState() => _HomeDashFilteredListState();
}

class _HomeDashFilteredListState extends State<HomeDashFilteredList> {

  bool viewAll=false;
  @override
  Widget build(BuildContext context) {
    final listFilter= viewAll == false ? widget.list.take(3).toList() : widget.list;
    return widget.list.isNotEmpty ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _titleBoldGrand(widget.label, context),
        const Gap(10),
        // Utilisation de SizedBox avec une hauteur fixe ou ListView shrinkWrap
        SizedBox(
          child: ListView.builder(
            shrinkWrap: true, // Permet à ListView de s'adapter à son contenu
            physics: const NeverScrollableScrollPhysics(), // Désactiver le scroll, si nécessaire
            itemCount: listFilter.length,
            itemBuilder: (context, index) {
              TaskModel task = listFilter[index];
              return Column(
                children: [
                  TaskCard(task: task, onTapOptions: () {}),
                  const Gap(marginVerticalCard + 5),
                ],
              );
            },
          ),
        ),
        //Voir tout
        viewAll== false && widget.list.length > 3 ? Center(
          child: IconButton(onPressed: (){
            setState(() {
              viewAll=true;
            });
          }, icon: const HeroIcon(HeroIcons.chevronDown,style: HeroIconStyle.solid,)),
        ):const Gap(0),
        //Reduire
        viewAll == true  ? Center(
          child: IconButton(onPressed: (){
            setState(() {
              viewAll=false;
            });
          }, icon: const HeroIcon(HeroIcons.chevronUp,style: HeroIconStyle.solid)),
        ):const Gap(0),
      ],
    ):const Gap(0);
  }

  Text _titleBoldGrand(String label, BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.bodyLarge,
    );
  }
}
