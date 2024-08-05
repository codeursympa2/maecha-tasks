import 'package:flutter/cupertino.dart';

void resetFields(List<TextEditingController> controllers){
  for (var ctrl in controllers) {
    ctrl.text="";
  }
}