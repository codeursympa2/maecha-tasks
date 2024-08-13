import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:maecha_tasks/src/constants/colors/light_mode/light_mode_colors.dart';

class SyncStatusMessage extends StatelessWidget {
  final bool isSyncing;

  const SyncStatusMessage({super.key, required this.isSyncing});

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: isSyncing,
        child: Container(
          color: infoColorLight,
          padding: const EdgeInsets.all(5),
          child:  const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(backgroundColor: backgroundLight,strokeWidth: 2,strokeAlign: 2,color:infoColorLight ,)),
              Gap(8),
              Text('Synchronisation en cours...',textAlign: TextAlign.center,style: TextStyle(color: Colors.white),),
            ],
          ),
        )
    );
  }
}
