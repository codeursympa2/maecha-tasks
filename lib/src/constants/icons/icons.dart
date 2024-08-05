
import 'package:heroicons/heroicons.dart';
import 'package:maecha_tasks/src/constants/colors/light_mode/light_mode_colors.dart';

HeroIcon eyesIcon(){
  return const HeroIcon(
    HeroIcons.eye,
    style: HeroIconStyle.outline, // Outlined icons are used by default.
    size: 30,
    color: primaryLight,
  );
}