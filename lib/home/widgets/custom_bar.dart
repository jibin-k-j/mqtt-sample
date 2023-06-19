import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class CustomBar extends StatelessWidget {
  final String current;
  final double currentMeasure;

  const CustomBar({Key? key, required this.current, required this.currentMeasure}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color barColor = const Color(0xFFE74444);
    switch (current) {
      case 'Y_Current':
        barColor = const Color(0xFFFFC90B);
        break;
      case 'B_Current':
        barColor = const Color(0xFF4880FD);
        break;
    }

    return Row(
      children: [
        //bar
        SizedBox(
          width: MediaQuery.of(context).size.width * .6,
          child: SfLinearGauge(
            minimum: -1.5,
            maximum: 100,
            showTicks: false,
            showAxisTrack: false,
            showLabels: false,
            animateAxis: true,
            animateRange: true,
            ranges: [
              LinearGaugeRange(
                startValue: -1.5,
                endValue: currentMeasure,
                startWidth: 20.0,
                endWidth: 20.0,
                color: barColor,
                edgeStyle: LinearEdgeStyle.bothCurve,
              )
            ],
          ),
        ),
        const Spacer(),
        Text(
          '${currentMeasure.toStringAsFixed(2)} A',
          style: GoogleFonts.getFont(
            'Quantico',
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
        ),
      ],
    );
  }
}
