import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:maecha_tasks/src/constants/colors/light_mode/light_mode_colors.dart';
import 'package:maecha_tasks/src/constants/numbers.dart';

class DashboardCard extends StatelessWidget {
  final String label;
  final int total;
  final IconData iconData;
   const DashboardCard({super.key, required this.label, required this.total, required this.iconData});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widthDashCard,
      height: heightDashCard,
      child: Card(
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadiusDashCard)),
        ),
        elevation: 5,
        color: primaryLight,
        child: Padding(
          padding:const EdgeInsets.all(paddingDashCard),
          child: SizedBox(
            height: 41,
            width: double.infinity - 20,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    width: 41,
                    height: 41,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: primaryIcon

                    ),
                    child:  Icon(iconData,color: backgroundLight,)
                ),
                const Gap(6),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,style: Theme.of(context).textTheme.displaySmall,),
                    Text(_getTotalString(total),style: Theme.of(context).textTheme.headlineMedium,),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getTotalString(int total){
    return total > 1 ? "$total tâches" : "$total tâche";
  }
}
