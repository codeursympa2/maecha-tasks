import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:maecha_tasks/global/services/easy_loading/custom_animation.dart';
import 'package:maecha_tasks/src/constants/colors/light_mode/light_mode_colors.dart';


class EasyLoadingService{

  static Future<EasyLoadingService> init() async{
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.cubeGrid
      ..loadingStyle = EasyLoadingStyle.custom
      ..maskType=EasyLoadingMaskType.black
      ..indicatorSize = 45.0
      ..radius = 5.0
      ..progressColor = backgroundLight
      ..backgroundColor = primaryLight
      ..indicatorColor = backgroundLight
      ..textColor = backgroundLight
      ..maskColor = Colors.blue.withOpacity(0.5)
      ..userInteractions = true
      ..dismissOnTap = false
      ..customAnimation = CustomAnimation();

    return  EasyLoadingService();
  }
}