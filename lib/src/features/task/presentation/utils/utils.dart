import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';

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


