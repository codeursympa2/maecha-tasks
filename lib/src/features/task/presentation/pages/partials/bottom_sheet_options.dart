import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:maecha_tasks/src/features/task/domain/entities/task/task_model.dart';

void bottomSheetOptions(
    {required BuildContext context, required TaskModel taskModel,  required VoidCallback onEditAction}){
  showModalBottomSheet<void>(
      context: context,
      // shape: const RoundedRectangleBorder(
      //   borderRadius: BorderRadius.zero
      // ),
      builder: (BuildContext context) {
    return SizedBox(
      height: 190,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ElevatedButton(onPressed: onEditAction , child: const Text('Editer')),
              const Gap(10),
              OutlinedButton(onPressed: (){
              }, child: const Text('Ajouter aux favoris')),
            ],
          ),
        ),
      ),
    );
});
}
