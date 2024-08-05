import 'package:flutter/material.dart';

Widget elevatedButton({
  required String value,
  required VoidCallback? onPressed
}){
  return ElevatedButton(
    onPressed: onPressed,
    child: Text(value),
  );
}
Widget outlinedButton({
  required String value,
  required VoidCallback onPressed
}){
  return OutlinedButton(
    onPressed: onPressed,
    child:  Text(value),
  );
}

