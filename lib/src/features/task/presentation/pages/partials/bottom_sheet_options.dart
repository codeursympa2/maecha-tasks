import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:maecha_tasks/src/constants/colors/light_mode/light_mode_colors.dart';
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
      child: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Container(
                width: 40,
                height: 5,
                decoration: const BoxDecoration(
                    color: secondaryTextLight,
                    borderRadius: BorderRadius.all(Radius.circular(20))
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Gap(20),
                  ElevatedButton(onPressed: onEditAction , child: const Text('Editer')),
                  const Gap(10),
                  OutlinedButton(onPressed: (){
                  }, child: const Text('Terminer')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
});
}
