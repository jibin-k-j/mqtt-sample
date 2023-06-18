import 'package:flutter/material.dart';
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
      case 'devices':
        return devicesLoading();
      case 'fan':
        return fanLoading();
      case 'gate':
        return gateLoading();
      case 'profile':
        return profileLoading();
      case 'faq':
        return faqLoading();
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
              color: Theme.of(context).colorScheme.background.withOpacity(.8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(backgroundColor: Colors.grey.withOpacity(.5)),
                Container(
                    width: widget.width * .2,
                    height: 10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey.withOpacity(.5),
                    )),
              ],
            ),
          ),
        ),
      );

  Widget fanLoading() => ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Shimmer(
          direction: const ShimmerDirection.fromLeftToRight(),
          child: Container(
            width: widget.width * .7,
            height: widget.height * .3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).colorScheme.background.withOpacity(.8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    width: widget.width * .15,
                    margin: const EdgeInsets.only(top: 20.0, left: 20.0),
                    height: 10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey.withOpacity(.5),
                    )),
                Container(
                    width: widget.width * .12,
                    margin: const EdgeInsets.only(top: 10.0, left: 20.0),
                    height: 6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey.withOpacity(.5),
                    )),
                Expanded(
                  child: Align(
                    alignment: AlignmentDirectional.center,
                    child: CircleAvatar(radius: 80.0, backgroundColor: Colors.grey.withOpacity(.5)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget gateLoading() => ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Shimmer(
          direction: const ShimmerDirection.fromLeftToRight(),
          child: Container(
            width: widget.width * .85,
            decoration: BoxDecoration(
              border: Border.all(width: 0.5, color: Colors.grey.withOpacity(.2)),
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey.withOpacity(.3),
            ),
          ),
        ),
      );

  Widget profileLoading() => ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Shimmer(
          direction: const ShimmerDirection.fromRightToLeft(),
          child: Container(
            width: widget.width,
            height: widget.height,
            color: Theme.of(context).colorScheme.surface,
            child: Icon(
              Icons.person_rounded,
              color: Colors.grey.withOpacity(.8),
              size: widget.width,
            ),
          ),
        ),
      );

  Widget faqLoading() => ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Shimmer(
          direction: const ShimmerDirection.fromLeftToRight(),
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              border: Border.all(width: 0.5, color: Colors.grey.withOpacity(.2)),
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey.withOpacity(.3),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(15, (index) => const Divider()),
            ),
          ),
        ),
      );
}
