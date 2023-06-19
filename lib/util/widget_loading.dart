import 'package:flutter/material.dart';
import 'package:mqtt_test/config/app_colors.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class WidgetLoading extends StatefulWidget {
  final double width;
  final double height;
  final String device;

  const WidgetLoading.rectangular({super.key, required this.width, required this.height, required this.device});

  @override
  State<WidgetLoading> createState() => _WidgetLoadingState();
}

class _WidgetLoadingState extends State<WidgetLoading> {
  @override
  Widget build(BuildContext context) {
    switch (widget.device) {
      case 'light':
        return devicesLoading();
      default:
        return devicesLoading();
    }
  }

  Widget devicesLoading() => ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Shimmer(
          direction: const ShimmerDirection.fromLeftToRight(),
          child: Container(
            width: widget.width * .4,
            height: widget.height * .1,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColors.surfaceColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(backgroundColor: Colors.grey.withOpacity(.5)),
                Container(
                    width: widget.width ,
                    height: widget.height,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey.withOpacity(.5),
                    )),
              ],
            ),
          ),
        ),
      );

}
