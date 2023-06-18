import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mqtt_test/config/app_colors.dart';
import 'package:mqtt_test/home/models/meter_info_model.dart';
import 'package:mqtt_test/home/models/meter_model.dart';
import 'package:lottie/lottie.dart';

import 'custom_bar.dart';
import 'custom_gauge.dart';

class EnergyMeter extends StatelessWidget {
  final MeterInfoModel meterInfoModel;
  final MeterModel? meterModel;
  final Size size;

  const EnergyMeter({Key? key, required this.size, required this.meterModel, required this.meterInfoModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return meterModel == null
        ? Center(
            child: Lottie.asset('asset/animation/power.json', height: size.height * .3),
          )
        : SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Text(
                  meterInfoModel.name,
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.w600),
                ),
                //current readings
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15.0),
                  margin: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(
                      width: 1,
                      color: Colors.grey.withOpacity(.5),
                    ),
                    color: AppColors.surfaceColor,
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Energy Consumption chart',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 15.0,
                        )),
                    SizedBox(height: size.height * .05),

                    //voltage reading
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: size.width * .25,
                              height: size.height * .1,
                              child: CustomGauge(voltage: 'R_Voltage', currentVoltage: meterModel!.voltage1.toInt()),
                            ),
                            SizedBox(
                              width: size.width * .25,
                              height: size.height * .1,
                              child: CustomGauge(voltage: 'Y_Voltage', currentVoltage: meterModel!.voltage2.toInt()),
                            ),
                            SizedBox(
                              width: size.width * .25,
                              height: size.height * .1,
                              child: CustomGauge(voltage: 'B_Voltage', currentVoltage: meterModel!.voltage3.toInt()),
                            )
                          ],
                        ),
                        Text('Voltage reading',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 13.0,
                            )),
                      ],
                    ),
                    SizedBox(height: size.height * .04),
                    //current reading
                    Column(
                      children: [
                        CustomBar(current: 'R_Current', currentMeasure: meterModel!.current1),
                        const SizedBox(height: 10.0),
                        CustomBar(current: 'Y_Current', currentMeasure: meterModel!.current2),
                        const SizedBox(height: 10.0),
                        CustomBar(current: 'B_Current', currentMeasure: meterModel!.current3),
                        const SizedBox(height: 10.0),
                        Text('Current Consumption',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 13.0,
                            )),
                      ],
                    )
                  ]),
                ),

                //overall readings
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15.0),
                  margin: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(
                      width: 1,
                      color: Colors.grey.withOpacity(.5),
                    ),
                    color: AppColors.surfaceColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset('asset/icons/power.svg'),
                          const SizedBox(width: 10.0),
                          Text('Overall Usage',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 15.0,
                              )),
                        ],
                      ),
                      const SizedBox(height: 20.0),

                      //voltage
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text('Voltage',
                              style: GoogleFonts.poppins(
                                  color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.w600)),
                          Text('${meterModel!.vAvg} V',
                              style: GoogleFonts.getFont(
                                'Quantico',
                                textStyle:
                                    const TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.w600),
                              )),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      //current
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text('Current',
                              style: GoogleFonts.poppins(
                                  color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.w600)),
                          Text('${meterModel!.aAvg} A',
                              style: GoogleFonts.getFont(
                                'Quantico',
                                textStyle:
                                    const TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.w600),
                              )),
                        ],
                      ), //
                      const SizedBox(height: 10.0),
                      // wattage
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text('Wattage',
                              style: GoogleFonts.poppins(
                                  color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.w600)),
                          Text('${meterModel!.wAvg} W',
                              style: GoogleFonts.getFont(
                                'Quantico',
                                textStyle:
                                    const TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.w600),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
