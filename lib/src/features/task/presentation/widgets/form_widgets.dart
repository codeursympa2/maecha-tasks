 import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

Widget formBuilderTextField({
  required GlobalKey<FormBuilderState> formKey,
  required BuildContext context,
  required String label,
  required String name,
  required  TextEditingController ctrl,
  int maxLines=1,
  required FocusNode focusNode,
  required TextInputAction textInputAction,
  //required void Function(String?)? onChanged,
  required List<String? Function(String?)> validators,
  bool focused=false,
}){
  return FormBuilderTextField(
    name: name,
    controller: ctrl,
    decoration: InputDecoration(
      labelText: label,
    ),
    autofocus: focused,
    style: Theme.of(context).textTheme.labelSmall,
    focusNode: focusNode,
    maxLines: maxLines,
    textInputAction: textInputAction,
    validator: FormBuilderValidators.compose(validators),
    onChanged: (value){
      formKey.currentState!.fields[name]?.validate();
    },
  );
}