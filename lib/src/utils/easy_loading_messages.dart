import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:maecha_tasks/src/constants/colors/light_mode/light_mode_colors.dart';



void showCustomMessage({required String message}) {
  //Modification du background
  EasyLoading.instance.backgroundColor =  primaryLight ;
  EasyLoading.show(
    status: message,
  );
}


//Customization du message
void showCustomSuccess({required String message}) {
  //Modification du background
  EasyLoading.instance.backgroundColor =  successColorLight ;
  EasyLoading.showSuccess(
    message,
    duration: const Duration(milliseconds: 2000),
    maskType: EasyLoadingMaskType.black,
    dismissOnTap: true,
  );

}

void showCustomError({required String message}) {
  //Modification du background
  EasyLoading.instance.backgroundColor = primaryLight;
  EasyLoading.showError(
    message,
    duration: const Duration(milliseconds: 2000),
    maskType: EasyLoadingMaskType.black,
    dismissOnTap: true,
  );
}
