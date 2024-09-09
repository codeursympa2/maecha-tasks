import 'package:flutter/material.dart';
import 'package:maecha_tasks/src/constants/colors/light_mode/light_mode_colors.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class ShimmerCard extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  final double? marginVertical;
  final double? marginHorz;
  const ShimmerCard({super.key,required this.width, required this.height, required this.radius,this.marginVertical,this.marginHorz});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      // This is the ONLY required parameter
      duration: const Duration(seconds: 1),
      // This is NOT the default value. Default value: Duration(seconds: 0)
      interval: const Duration(seconds: 1),
      // This is the default value
      color: Colors.black12,
      // This is the default value
      colorOpacity: 0.2,
      // This is the default value
      enabled: true,
      // This is the default value
      direction: const ShimmerDirection.fromLTRB(),
      // This is the ONLY required parameter
      child: Container(
        decoration: BoxDecoration(
          color: skeletonColorLight,
          borderRadius: BorderRadius.all(Radius.circular(radius)),
        ),
        width: width,
        height: height,
        margin: EdgeInsets.symmetric(vertical: marginVertical ?? 0,horizontal: marginHorz ?? 0),
      ),
    );
  }
}
