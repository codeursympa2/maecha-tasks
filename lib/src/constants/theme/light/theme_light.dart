import 'package:flutter/material.dart';
import 'package:maecha_tasks/src/constants/colors/light_mode/light_mode_colors.dart';
import 'package:maecha_tasks/src/constants/numbers.dart';
import 'package:maecha_tasks/src/constants/strings/fonts_strings.dart';


const TextTheme textTheme=TextTheme(
  //Pacifico 20 bold
  headlineLarge: TextStyle(
    fontFamily: pacifico,
    color: primaryLight,
    fontSize: headlineLargeSize
  ),
  //Quicksand 20 bold button
  labelLarge: TextStyle(
    fontFamily: quicksand,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    fontSize: headlineLargeSize
  ),
  //Quicksand 16 bold
  labelMedium: TextStyle(
    fontFamily: quicksand,
    fontWeight: FontWeight.bold,
    fontSize: labelMediumSize
  ),
  //Quicksand 16 bold
  bodyMedium: TextStyle(
      fontFamily: quicksand,
      fontWeight: FontWeight.bold,
      color: primaryLight,
      fontSize: labelMediumSize
  ),
  //Quicksand 14 bold
  labelSmall: TextStyle(
      fontFamily: quicksand,
      fontWeight: FontWeight.bold,
      fontSize: labelSmallSize
  ),
  //Quicksand 14 regular
  titleLarge: TextStyle(
      fontFamily: quicksand,
      fontSize: labelSmallSize
  ) ,
  //Quicksand 12 regular
  titleMedium: TextStyle(
      fontFamily: quicksand,
      fontSize: titleMediumSize
  ),
  //Quicksand 12 bold
  titleSmall:  TextStyle(
      fontFamily: quicksand,
      fontWeight: FontWeight.bold,
      fontSize: titleMediumSize
  ),
  bodySmall: TextStyle(
      fontFamily: quicksand,
      fontSize: titleMediumSize,
      fontWeight: FontWeight.bold,
      color: primaryLight
  ),
  //title Page
  displayLarge:  TextStyle(
      fontFamily: quicksand,
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: primaryTextLight
  ),
  displayMedium: TextStyle(
      fontFamily: quicksand,
      color: primaryTextLight,
      fontSize: labelMediumSize
  )
);


ColorScheme colorScheme=ColorScheme.fromSeed(
    seedColor:primaryLight,
    background: backgroundLight
);

const Size sizeButtons=Size(double.infinity, buttonHeight);

RoundedRectangleBorder borderRadius=RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(roundedButton),
);


TextStyle buttonsTextStyle= const TextStyle(
    fontFamily: quicksand,
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: primaryLight
);

TextStyle hintStyle= const TextStyle(
    fontFamily: quicksand,
    fontSize: 16,
    //fontWeight: FontWeight.bold,
    color: secondaryTextLight
);
ElevatedButtonThemeData elevatedButtonTheme=ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
      textStyle: buttonsTextStyle,
      backgroundColor: primaryLight,
      disabledForegroundColor: secondaryTextLight,
      foregroundColor: backgroundLight,
      shape: borderRadius,
      minimumSize: sizeButtons
  ),
);
OutlinedButtonThemeData outlinedButtonTheme=OutlinedButtonThemeData(
  style:OutlinedButton.styleFrom(
    textStyle: buttonsTextStyle,
    side: const BorderSide(color: primaryLight, width: 2),
    foregroundColor: primaryLight,
    disabledForegroundColor: secondaryTextLight,
    shape: borderRadius,
    minimumSize: sizeButtons
  ),
);

//Input decoration
InputDecorationTheme inputDecorationTheme=InputDecorationTheme(
    hintStyle: hintStyle,
    floatingLabelStyle: hintStyle,
    labelStyle: hintStyle,
    errorBorder: inputBorder(borderColor: dangerLight),
    enabledBorder: inputBorder(borderColor: primaryTextLight),
    focusedBorder: inputBorder(borderColor: primaryLight),
    focusedErrorBorder: inputBorder(borderColor: dangerLight),
    iconColor: primaryLight,

);

OutlineInputBorder inputBorder({required Color borderColor}){
  return OutlineInputBorder(
    borderSide: BorderSide(
        width: 2,
        color: borderColor
    ),
    borderRadius: const BorderRadius.all(Radius.circular(10)),
  );
}