import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class CustomGauge extends StatefulWidget {
  final String voltage;
  final int currentVoltage;

  const CustomGauge({Key? key, required this.voltage,required this.currentVoltage})
      : super(key: key);

  @override
  State<CustomGauge> createState() => _CustomGaugeState();
}

class _CustomGaugeState extends State<CustomGauge> {
  @override
  Widget build(BuildContext context) {

    //setting gauge color
    SweepGradient gradient = const SweepGradient(
      colors: [
        Color(0x40EF4444),
        Color(0x50EF4444),
        Color(0x70EF4444),
        Color(0xCCEF4444),
        Color(0xffEF4444),
      ],
    );

    switch (widget.voltage) {
      case 'Y_Voltage':
        gradient = const SweepGradient(
          colors: [
            Color(0x40FFC90B),
            Color(0x50FFC90B),
            Color(0x70FFC90B),
            Color(0xCCFFC90B),
            Color(0xffFFC90B),
          ],
        );
        // voltage = widget.energyData.yVoltage;
        break;
      case 'B_Voltage':
        gradient = const SweepGradient(
          colors: [
            Color(0x404880FF),
            Color(0x504880FF),
            Color(0x704880FF),
            Color(0xCC4880FF),
            Color(0xff4880FF),
          ],
        );
        // voltage = widget.energyData.bVoltage;
        break;
    }

    //main section
    return SfRadialGauge(
      enableLoadingAnimation: true,
      axes: [
        RadialAxis(
          minimum: 0,
          maximum: 250,
          startAngle: 180,
          endAngle: 360,
          showLabels: false,
          showTicks: false,
          showAxisLine: false,
          ranges: [
            GaugeRange(
              startValue: 0,
              endValue: 250,
              startWidth: 20.0,
              endWidth: 20.0,
              gradient: gradient,
            )
          ],
          pointers: [
            NeedlePointer(
              value: double.parse(widget.currentVoltage.toString()),
              enableAnimation: true,
              needleLength: .95,
              needleEndWidth: 3.0,
              needleColor: const Color(0xffD9D9D9),
              knobStyle: const KnobStyle(
                color: Color(0xffD9D9D9),
                knobRadius: 0.1,
              ),
            )
          ],
          annotations: [
            GaugeAnnotation(
              widget: Text(
                '${widget.currentVoltage} V',
                style: GoogleFonts.getFont(
                  'Quantico',
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ),
              angle: 90,
              positionFactor: 0.5,
            ),
          ],
        )
      ],
    );
  }
}
