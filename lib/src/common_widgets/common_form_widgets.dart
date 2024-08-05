import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:maecha_tasks/src/constants/colors/light_mode/light_mode_colors.dart';

TextFormField texEditingField(
    {
      required String label,
      required BuildContext context,
      required  TextEditingController ctrl,
      int maxLines=1,
      required FocusNode focusNode,
      required TextInputAction textInputAction,
      required void Function(String value) onChanged,
      required String? Function(String?) validator,
      required void Function(String) onFieldSubmitted,
      bool focused=false,
    })
{
  return TextFormField(
      controller: ctrl,
      maxLines: maxLines,
      autofocus: focused,
      cursorColor: primaryLight,
      style: Theme.of(context).textTheme.labelSmall,
      focusNode: focusNode,
      scrollPhysics: const BouncingScrollPhysics(),
      textInputAction: textInputAction,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
          label:Text(label),
      ),
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted);

}


Widget passwordFieldForm({
  required String label,
  required BuildContext context,
  required  TextEditingController ctrl,
  required FocusNode focusNode,
  required TextInputAction textInputAction,
  required void Function(String value) onChanged,
  required String? Function(String?) validator,
  required void Function(String) onFieldSubmitted,
  required bool obscureText,
  required VoidCallback onTapSuffixIcon,
  bool autofocus=false
}){
  return TextFormField(
      controller: ctrl,
      obscureText: obscureText,
      autofocus: autofocus,
      cursorColor: primaryLight,
      style: Theme.of(context).textTheme.labelSmall,
      focusNode: focusNode,
      scrollPhysics: const BouncingScrollPhysics(),
      textInputAction: textInputAction,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        label:Text(label),
        suffixIcon: GestureDetector(
        onTap: onTapSuffixIcon,
        child: _getIconPasswordField(obscureText),
        ),
      ),
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted);
}

Widget _getIconPasswordField(bool obscureText) {
  const icon=HeroIcons.eye;
  if (!obscureText) {
    return const  HeroIcon(
      icon,
    );
  }
  return const HeroIcon(
    icon,
    style: HeroIconStyle.solid,
  );
}


Widget buttonTextCustomize(BuildContext context,String text,VoidCallback onPressed){
  return TextButton(
    style: const ButtonStyle(
      backgroundColor: MaterialStatePropertyAll<Color>(Colors.transparent),
      foregroundColor: MaterialStatePropertyAll<Color>(primaryLight),
    ),
    onPressed: onPressed,
    child:  Text(text,style: Theme.of(context).textTheme.bodySmall,),
  );
}
